import boto3

from sys import argv

def get_name(aws_obj):
  names = list(tag['Value'] for tag in aws_obj['Tags'] if tag['Key'] == 'Name')

  if len(names) != 1:
    print('No name for object: {}'.format(aws_obj))
    return '--unknown--'
  return names[0]

def get_filter(key, val):
  return {'Filters': [{'Name':key, 'Values':[val]}]}

def get_vpc_resource(call, v_id, resouce_key):
  return call(**get_filter('vpc-id', v_id))[resouce_key]

def parse_subnet(s):
  return {'subnet_id': s['SubnetId'], 'cidr': s['CidrBlock'], 'name': get_name(s)}

def parse_route(route):
  if 'DestinationPrefixListId' in route:
    return {'dst': route['DestinationPrefixListId'], 'state': route['State'],
            'gateway_id': route['GatewayId'], 'type': 'svc_gateway'}

  elif 'VpcPeeringConnectionId' in route:
    return {'dst': route['DestinationCidrBlock'], 'state': route['State'],
            'peer_id': route['VpcPeeringConnectionId'], 'type': 'vpc_peer'}

  elif 'GatewayId' in route:
    return {'dst': route['DestinationCidrBlock'], 'state': route['State'],
            'gateway_id':route['GatewayId'], 'type': 'vpn_gateway'}

  elif 'NatGatewayId' in route:
    return {'dst': route['DestinationCidrBlock'], 'state': route['State'],
            'nat_id': route['NatGatewayId'], 'type': 'nat'}

  elif 'NetworkInterfaceId' in route:
    return {'dst': route['DestinationCidrBlock'], 'state': route['State'],
            'eni_id': route['NetworkInterfaceId'], 'type': 'eni'}

  raise Exception("unknown route type {}".format(r))

def enrich_peer(route, peer_cache, client):
  p_id = route['peer_id']
  if p_id not in peer_cache:
    filter = get_filter('vpc-peering-connection-id', p_id)
    peer = client.describe_vpc_peering_connections(**filter)['VpcPeeringConnections']

    if len(peer) != 1:
      print("unknown peer: {}".format(p_id))
      peer_cache[p_id] = {'name': 'unknown', 'peer_id': p_id}

    else:
      peer = peer[0]
      peer_cache[p_id] = {'name': get_name(peer),
                          'status': peer['Status']['Code'],
                          'peer_id': p_id,
                          'accepter_vpc_id': peer['AccepterVpcInfo']['VpcId'],
                          'accepter_cidr': peer['AccepterVpcInfo']['CidrBlock'],
                          'requester_vpc_id': peer['RequesterVpcInfo']['VpcId'],
                          'requester_cidr': peer['RequesterVpcInfo']['CidrBlock']}

  route['peer_name'] = peer_cache[p_id]['name']
  return route


def main():
  client = boto3.client('ec2')
  vpc_list = client.describe_vpcs()['Vpcs']
  peers = {}
  res = {'vpcs':[]}

  for v in vpc_list:
    name = get_name(v)
    v_id = v['VpcId']
    vpc = {'vpc_id': v_id, 'cidr': v['CidrBlock'], 'name': get_name(v), 'route_tables': []}

    subnets = {s['SubnetId']:s for s in get_vpc_resource(client.describe_subnets, v_id, 'Subnets')}

    route_tables = get_vpc_resource(client.describe_route_tables, v_id, 'RouteTables')

    main_rtb = None

    for orig_rtb in route_tables:
      r_id = orig_rtb['RouteTableId']
      rtb = {'rtb_id': r_id, 'name': get_name(orig_rtb), 'subnets': [], 'routes': []}

      for assoc in orig_rtb['Associations']:
        if assoc['Main']:
          rtb['main'] = True
          main_rtb = rtb
          continue

        snet = subnets[assoc['SubnetId']]
        snet['associated_rtb_id'] = r_id
        rtb['subnets'].append(parse_subnet(snet))

      for route in orig_rtb['Routes']:
        r = parse_route(route)

        if r['type'] == 'vpc_peer':
          r = enrich_peer(r, peers, client)

        rtb['routes'].append(r)

      vpc['route_tables'].append(rtb)

    # Find all the subnets that have implicit route table associations
    for s_id, details in subnets.items():
      if 'associated_rtb_id' in details:
        continue
      details['implicit_rtb'] = True
      main_rtb['subnets'].append(parse_subnet(details))

    res['vpcs'].append(vpc)

  res['peers'] = list(peers.values())

  return res

if __name__ == '__main__':

  res = main()

  if len(argv) > 1 and argv[1] == '--json':
    import json
    print(json.dumps(res))

  else:
    for v in res['vpcs']:
      print('{vpc_id} {cidr} {name}'.format(**v))

      for rtb in v['route_tables']:
        if 'main' in rtb:
          print('\tMAIN')

        print("\t{rtb_id} {name}".format(**rtb))
        for s in rtb['subnets']:
          print('\t{subnet_id} {cidr} {name}'.format(**s))

        for r in rtb['routes']:
          print('\t\t{}'.format(r))





