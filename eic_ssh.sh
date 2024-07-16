#!/bin/bash
set -e # we set '-u' (unused variables) once we've checked CLI args
set -o pipefail

NOT_SET="not-set" # Error check value

function usage(){
  echo -e "usage:\t\t${0} [TARGET_IP|-n NAME] [USER] [NO_SSH] [PUBLIC_IP]\n"
  echo -e "TARGET_IP\tIP of the target EC2 instance"
  echo -e "-n NAME\t\tName of the instance to search for"
  echo -e "USER\t\tUser to log into both boxes as (default: 'ubuntu')"
  echo -e "NO_SSH\t\tDon't open an SSH session (e.g. if you want to run ansible)"
  echo -e "PUBLIC_IP\tThe target IP is the instance's public address."
}

function print-error(){
  RED_BOLD="\033[31m\033[1m"
  RESET="\033[0m"
  echo -e "${RED_BOLD}ERROR:${RESET} ${1}"
  usage
  exit 1
}

function searchForIdBy(){ # search term, value
  IPFilter="Name=${1},Values=${2}"
  filterId="if (.Reservations | length) == 1 then .Reservations[].Instances[] | .InstanceId else \"${NOT_SET}\" end"

  aws ec2 describe-instances --filter "${IPFilter}" | jq -r "${filterId}"
}

function getValueForId() { # ec2 id, value to return
  filterAz="if (.Reservations | length) == 1 then .Reservations[].Instances[] | ${2} else \"${NOT_SET}\" end"

  aws ec2 describe-instances --instance-id "${1}" | jq -r "${filterAz}"
}

function check-set(){
  if [[ "${1}" == "${NOT_SET}" ]]; then
    print-error "${2}"
  fi
}

# No args: print help
if [[ "${1}" == "-h" || "${1}" == "" ]]; then
  usage
  exit 0
fi

#
# Check things are as we need them.
#

if [[ ! -x $(command -v aws) ]]; then
  print-error "aws needs to be installed"
fi

if [[ ! -x $(command -v jq) ]]; then
  print-error "jq needs to be installed"
fi

if [[ "${1}" == "-n" ]]; then
  TARGET_IP="${NOT_SET}"
  NAME="${2:-${NOT_SET}}"
  check-set "${NAME}" "NAME not set"

  USER="${3:-ubuntu}"
  NO_SSH="${4:-${NOT_SET}}"
  PUBLIC_IP="${NOT_SET}"

else
  TARGET_IP="${1:-${NOT_SET}}"
  NAME="${NOT_SET}"
  check-set "${TARGET_IP}" "TARGET_IP not set"

  USER="${2:-ubuntu}"
  NO_SSH="${3:-${NOT_SET}}"
  PUBLIC_IP="${4:-${NOT_SET}}"
fi

if [[ "${CMD}" == "" ]]; then
  CMD=""
fi

# Exit on unbound variables from here
set -u
if [[ "${NAME}" != "${NOT_SET}" ]]; then
  TARGET_ID=$(searchForIdBy "tag:Name" "*${NAME}*")
  TARGET_IP=$(getValueForId "${TARGET_ID}" ".PrivateIpAddress")
elif [[ "${PUBLIC_IP}" == "${NOT_SET}" ]]; then
  TARGET_ID=$(searchForIdBy "private-ip-address" "${TARGET_IP}")
else
  TARGET_ID=$(searchForIdBy "network-interface.association.public-ip" "${TARGET_IP}")
fi
TARGET_AZ=$(getValueForId "${TARGET_ID}" ".Placement.AvailabilityZone")

check-set "${TARGET_ID}" "An ID for TARGET_IP (${TARGET_IP}) could not be found by EC2"
check-set "${TARGET_AZ}" "An AZ for TARGET_IP (${TARGET_IP}) could not be found by EC2"

# Generate a new key (eic_rsa) with no password
TMP_KEY_FILE=$(mktemp -d)
# Trap the exit so we can clean up the generated key
trap '{ rm -rf "${TMP_KEY_FILE}" ; echo "cleaned" ; }' EXIT
ssh-keygen -f "${TMP_KEY_FILE}/eic_rsa" -t rsa -N ''

aws ec2-instance-connect send-ssh-public-key \
                         --instance-id "${TARGET_ID}" \
                         --instance-os-user "${USER}" \
                         --availability-zone "${TARGET_AZ}" \
                         --ssh-public-key "file://${TMP_KEY_FILE}/eic_rsa.pub"

if [[ "${NO_SSH}" == "${NOT_SET}" ]];
then
  ssh -i "${TMP_KEY_FILE}/eic_rsa" "${USER}@${TARGET_IP}" "${CMD}"
else
  echo ssh -i "${TMP_KEY_FILE}/eic_rsa" "${USER}@${TARGET_IP}" "${CMD}"
fi
