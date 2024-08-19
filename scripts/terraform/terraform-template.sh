# Create the main directory
mkdir -p terraform_template

# Navigate into the project directory
cd terraform_template

# Create environment directories
mkdir -p environments/dev environments/prod environments/staging

# Create module directories
mkdir -p modules/network modules/compute modules/security modules/lambdas

# Create files in the root directory
# touch main.tf variables.tf outputs.tf terraform.tfvars

# Create files in each environment directory
touch environments/dev/main.tf environments/dev/variables.tf environments/dev/outputs.tf environments/dev/terraform.tfvars environments/dev/provider.tf environments/dev/backend.tf
# touch environments/prod/main.tf environments/prod/variables.tf environments/prod/outputs.tf environments/prod/terraform.tfvars
# touch environments/staging/main.tf environments/staging/variables.tf environments/staging/outputs.tf environments/staging/terraform.tfvars

# Create files in each module directory
# touch modules/network/main.tf modules/network/variables.tf modules/network/outputs.tf
# touch modules/compute/main.tf modules/compute/variables.tf modules/compute/outputs.tf
# touch modules/security/main.tf modules/security/variables.tf modules/security/outputs.tf
touch modules/lambdas/main.tf modules/lambdas/variables.tf modules/lambdas/outputs.tf