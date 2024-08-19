#!/bin/zsh

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
NORMAL=$(tput sgr0)

# Get script directory
SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if ! [ -f ~/.aws/credentials ]; then
  echo "$YELLOW [WARNING] AWS credentials not found. Run 'aws configure' $NORMAL"
  aws configure
fi
if ! [ -f ~/.terraform.d/credentials.tfrc.json ]; then
  echo "$YELLOW [WARNING] Terraform credentials not found. Run 'terraform login' $NORMAL"
  terraform login
fi

cd $ROOT_DIR/$TF_WORKING_DIR

source $SCRIPT_DIR/01-hcp-terraform-setup.sh

terraform init
echo "$GREEN [INFO] Terraform init completed. Now you can perform following operations in the $ROOT_DIR/$TF_WORKING_DIR directory:
- terraform fmt
- terrascan
- tflint
- terraform plan -out=deploy.tfplan
- terraform apply -auto-approve deploy.tfplan $NORMAL"
