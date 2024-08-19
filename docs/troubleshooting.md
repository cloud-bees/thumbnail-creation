# Troubleshooting

## How to create HCP Terraform ORGANIZATION?

- [Using web browser](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-sign-up#create-an-organization)
- Using Terraform CLI

    ```Terraform
    required_providers {
        tfe = {
          version = "~> 0.57.0"
        }
    }
    resource "tfe_organization" "test-organization" {
      name  = "my-org-name"
      email = "admin@company.com"
    }

    resource "tfe_project" "test" {
      organization = tfe_organization.test-organization.name
      name         = "projectname"
    }
    ```

## Cannot import name '_imaging' from 'PIL'

  Make sure to install Python packages with python version and platform matching
  Python Lambda runtime version and architecture
  <https://stackoverflow.com/questions/57197283/aws-lambda-cannot-import-name-imaging-from-pil>
