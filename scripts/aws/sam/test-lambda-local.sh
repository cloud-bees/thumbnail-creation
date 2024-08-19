#!/bin/zsh

if ! [ -x "$(command -v sam)" ]; then
  echo "Error: sam is not installed. Please installed it via" \
  "https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-getting-started.html" >&2
  exit 1
fi

if ! [ -f ~/.aws/credentials ]; then
  echo "Error: AWS credentials not found. Please configure it via 'aws configure'" >&2
  exit 1
fi

cd $ROOT_DIR/src
# update template.yaml with the bucket name
sed 's/!Ref BUCKET_NAME/'$TF_VAR_s3_origin'/g' $PWD/_template.yaml > $PWD/template.yaml
sed -i 's/!Ref PYTHON_VERSION/'$PYTHON_VERSION'/g' $PWD/template.yaml
if [ "$(uname -m)" = "aarch64" ]; then
  ARCHITECTURE="arm64"
fi

sed -i 's/!Ref ARCHITECTURE/'$ARCHITECTURE'/g' $PWD/template.yaml

# update event.json with the s3 bucket name
sed 's/!Ref BUCKET_NAME/'$TF_VAR_s3_origin'/g' $PWD/events/_event.json > $PWD/events/event.json

# upload test image to s3
# check if the bucket and test image exists
aws s3api head-bucket --bucket $TF_VAR_s3_origin 1>/dev/null
aws s3api head-object --bucket $TF_VAR_s3_origin --key test.jpg 1>/dev/null || aws s3 cp $PWD/events/test.jpg s3://$TF_VAR_s3_origin

sam build
sam local invoke -e $PWD/events/event.json