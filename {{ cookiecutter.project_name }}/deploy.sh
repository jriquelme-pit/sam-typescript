#!/bin/bash

: "${STACK_NAME:=$1}"
: "${S3_BUCKET:=$2}"

if [[ -z ${STACK_NAME} ]] ; then
  echo "No stackname was provided."
  echo "Use: sh deploy.sh <STACK_NAME> <COGNITO_UP> <S3_BUCKET>"
  exit 2
fi


if [[ -z ${S3_BUCKET} ]] ; then
  echo "No S3 bucket defined, using 'cf-bucket'."
  S3_BUCKET="cf-bucket"
fi

FILENAME=$(echo $RANDOM.${STACK_NAME} | openssl dgst -sha1 | sed 's/^.* //')
BUCKET="s3://$S3_BUCKET/$STACK_NAME/$FILENAME"

echo ${BUCKET}
echo ${FILENAME}

aws s3 cp openapi.yaml ${BUCKET} --sse

sh ./build.sh

exit 0
