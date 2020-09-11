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

echo '...cleaning distribution folder'
rm -rf dist && mkdir dist && mkdir dist/layers && mkdir dist/tmp

echo '...building production libraries node_modules'
cd ./libs && rm -rf node_modules && npm install && tsc && cd ..

echo '...packaging layer'
cd ./src && claudia pack --force --output ../dist/tmp/layer.zip >> /dev/null && cd ..
unzip dist/tmp/layer.zip 'node_modules/*' -d dist/layers/nodejs/ >> /dev/null && rm -rf dist/tmp
cd ./dist/layers && zip -r9 ../layers.zip nodejs >> /dev/null && cd ../.. &&

echo '...building production source code node_modules'
cd ./src && rm -rf node_modules && npm install --production >> /dev/null && cd ..
cd ./src && tsc && cd ..

sam package --output-template-file packaged.yaml --template-file cloudformation.yaml --s3-bucket ${S3_BUCKET} \
&& sam deploy --template-file packaged.yaml --capabilities CAPABILITY_NAMED_IAM --stack-name ${STACK_NAME}

exit 0
