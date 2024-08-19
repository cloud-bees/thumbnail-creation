terraform {
  // https://developer.hashicorp.com/terraform/cli/cloud/settings
  cloud {
    # organization = ""
    workspaces {
      # name = "workspace-name"
      # project = "project-name"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
    }
  }
  required_version = "~> 1.2"
}
