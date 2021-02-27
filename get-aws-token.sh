#!/bin/bash

MFA_LOCATION="${HOME}/.aws/mfa"

function help(){
    echo "usage: ${0} [FLAGS] TOKEN"
    echo
    echo -e "-h\tPrint this message"
    echo "Reads mfa arn from ${MFA_LOCATION}"
}

GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m' # No Color"

function error_message(){
    echo -e "${RED}[error_message]:${RESET} ${1}"
    help
}

if [[ "${1}" == "-h" ]]; then
    help
    return 0
fi

if [[ -z $(which jq) ]]; then
    error_message "'jq' not installed."
    return 1
fi

if [[ -z $(which aws) ]]; then
    error_message "'aws' not installed."
    return 2
fi

NOT_SET="not-set"
TOKEN="${1:-$NOT_SET}"

if [[ "${TOKEN}" == "${NOT_SET}" ]]; then
   error_message "Token not set."
   return 3
fi

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

MFA=$(cat "${MFA_LOCATION}")
CREDS=$(aws sts get-session-token --serial-number "${MFA}" --token-code "${TOKEN}")

AWS_ACCESS_KEY_ID=$(echo "${CREDS}" | jq -r '.Credentials.AccessKeyId')
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
AWS_SECRET_ACCESS_KEY=$(echo "${CREDS}" | jq -r '.Credentials.SecretAccessKey')
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
AWS_SESSION_TOKEN=$(echo "${CREDS}" | jq -r '.Credentials.SessionToken')
export AWS_SESSION_TOKEN="${AWS_SESSION_TOKEN}"
EXPIRES=$(echo "${CREDS}" | jq -r '.Credentials.Expiration')

export AWS_PAGER=""

echo -e "AWS session token set, expires at: ${GREEN}${EXPIRES}${RESET}"
