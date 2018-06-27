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

echo "Running:   kubectl get \"$RESC\" | grep -ie \"$EXPR\" | cut -d ' ' -f1"

for res in $(kubectl get "$RESC" | grep -ie "$EXPR" | cut -d ' ' -f1); do
  if [[ ! -z $DELETE ]]; then
    kubectl delete "$RESC" "$res"
  else
    echo "$res"
  fi
done
