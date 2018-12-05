#! /bin/bash

set -e

if [[ -z $(command -v kubectl) ]]; then
  echo "kubectl not found, please check that it is installed"
  exit 1
fi

function usage () {
  echo "usage: $0 [-h] EXPRESSION RESOUCE [DELETE]"
  echo "-h          Print this message."
  echo "EXPRESSION  Should be a case-insensitive expression to pass to grep for selecting resources"
  echo "RESOUCE     What sort of kubernetes resource to delete."
  echo "DELETE      Set to delete the found resources (otherwise prints their names)"
  exit 0
}

if [[ -z $1 ]] || [[ $1 == '-h' ]]; then
  usage
elif [[ ! -z $2 ]]; then
  EXPR=$1
  RESC=$2
fi

DELETE=$3

echo -e "Running:   kubectl get \"$RESC\" | grep -ie \"$EXPR\" | cut -d ' ' -f1\nGot:\n"

resources=$(kubectl get --no-headers "$RESC" | grep -ie "$EXPR" | cut -d ' ' -f1)
echo -e "$resources\n"

if [[ -z $DELETE ]]; then
  exit 0;
fi

while true; do
  read -rp "Do you wish to delete these $RESC? [yN]" yn
  case $yn in
    [Yy]* ) DELETE=true; break;;
    * ) exit 0;;
  esac
done

for res in $resources; do
  kubectl delete "$RESC" "$res"
done

echo "Done"
