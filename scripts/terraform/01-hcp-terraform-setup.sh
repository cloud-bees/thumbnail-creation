#!/bin/zsh

TF_TOKEN=$(cat ~/.terraform.d/credentials.tfrc.json | jq -r '.credentials."app.terraform.io".token')
if [[ -z $TF_TOKEN ]]; then
  echo "$RED [ERROR] TF_TOKEN is not set $NORMAL"
  exit 1
fi
if ! [ -f ~/.aws/credentials ]; then
  echo "$RED [ERROR] AWS credentials not found. Please configure it via 'aws configure' $NORMAL"
  exit 1
fi

hcp_request() {
  data=$1
  url=$2

  echo $data > tmp
  response=$(curl --header "Authorization: Bearer $TF_TOKEN" \
    --request POST \
    --header "Content-Type: application/vnd.api+json" \
    --data @tmp \
    $url
  )
  echo $response
  if [[ $response == *"errors"* ]]; then
    if [[ $response == *"has already been taken"* ]]; then
      echo "$YELLOW [WARNING] resource already exists $NORMAL"
    else
      echo "$RED [ERROR] creating resource $NORMAL"
      exit 1
    fi
  fi
  rm -rf tmp
}

# Create a project
data="{
  \"data\": {
    \"attributes\": {
      \"name\": \"$TF_CLOUD_PROJECT\"
    },
    \"type\": \"projects\"
  }
}"

hcp_request $data "https://app.terraform.io/api/v2/organizations/$TF_CLOUD_ORGANIZATION/projects"

# Get the project id
response=$(curl --header "Authorization: Bearer $TF_TOKEN" \
  "https://app.terraform.io/api/v2/organizations/$TF_CLOUD_ORGANIZATION/projects?filter%5Bnames%5D=$TF_CLOUD_PROJECT")

project_id=$(echo $response | jq -r '.data[0].id')

# Create a workspace
data="{
  \"data\": {
    \"attributes\": {
      \"name\": \"$TF_WORKSPACE\",
      \"working-directory\": \"$TF_WORKING_DIR\"
    },
    \"type\": \"workspaces\",
    \"relationships\": {
      \"project\": {
        \"data\": {
          \"type\": \"projects\",
          \"id\": \"$project_id\"
        }
      }
    }
  }
}"

hcp_request $data "https://app.terraform.io/api/v2/organizations/$TF_CLOUD_ORGANIZATION/workspaces"

# Get the workspace id
response=$(curl --header "Authorization: Bearer $TF_TOKEN" \
  "https://app.terraform.io/api/v2/organizations/$TF_CLOUD_ORGANIZATION/workspaces?filter%5Bnames%5D=$TF_WORKSPACE")
workspace_id=$(echo $response | jq -r '.data[0].id')

# Set AWS credentials
data="{
  \"data\": {
    \"type\": \"vars\",
    \"attributes\": {
      \"key\": \"AWS_ACCESS_KEY_ID\",
      \"value\": \"$(cat ~/.aws/credentials | grep aws_access_key_id | awk '{print $3}')\",
      \"category\": \"env\",
      \"sensitive\": \"true\"
    }
  }
}"

hcp_request $data "https://app.terraform.io/api/v2/workspaces/$workspace_id/vars"

data="{
  \"data\": {
    \"type\": \"vars\",
    \"attributes\": {
      \"key\": \"AWS_SECRET_ACCESS_KEY\",
      \"value\": \"$(cat ~/.aws/credentials | grep aws_secret_access_key | awk '{print $3}')\",
      \"category\": \"env\",
      \"sensitive\": \"true\"
    }
  }
}"

hcp_request $data "https://app.terraform.io/api/v2/workspaces/$workspace_id/vars"

# echo "Allow the script to set AWS credentials into HCP Terraform workspace?" \
#   "(Required aws credentials is set in ~/.aws/credentials) [y/n]: "
# read answer
# if [[ $answer == "y" ]]; then
# fi