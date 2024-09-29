# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
<!-- markdownlint-disable no-duplicate-heading -->
## [Unreleased]

### Added

- Github Action

### Fixed

- pre-commit install-hooks not installing Hadolint binary [#886](https://github.com/hadolint/hadolint/issues/886)
- The latest Devcontainer feature is not compatible [#4](https://github.com/cloud-bees/thumbnail-creation/issues/4)

### Changed

- Dockerfile to use multi-stage builds for installing Miniconda3
- Enable Dependabot in Repository setting
- README subtitle: Architecture Diagram instead workflow

## [v1.0.0] - 2024-09-07

### Added

- **Devcontainer**: Set up a quick-start development environment.
- **AWS SAM Integration**: Added a script to test Lambda functions locally.
- **Lambda Function**: Implemented a Python Lambda function to generate thumbnails and update metadata in DynamoDB.
- **Terraform Infrastructure**: Deployed AWS infrastructure for thumbnail generation using Terraform.
- **HCP Terraform**: Managed Terraform state in the cloud with HCP Terraform.
- **Pre-commit Hooks**: A pre-commit githook was added to enforce code quality, formatting, and security checks before committing changes. The following tools are integrated:
  - **YAML Validation**: check-yaml for validating YAML files.
  - **Git Commit Message Linting**: gitlint for enforcing Git commit message conventions.
  - **Security Scanning**:
    - gitleaks: Scans Git repositories for sensitive information leaks.
    - trufflehog: Searches repositories for secrets and sensitive data.
    - talisman-commit: Prevents sensitive data from being committed.
  - **Python Code Formatting**: ruff for enforcing Python code style and formatting.
  - **Terraform Tools**:
    - terraform fmt: Formats Terraform code.
    - terraform validate: Validates Terraform configurations.
    - terraform-docs: Generates Terraform module documentation.
    - tflint: A linter for Terraform code.
    - trivy (which includes tfsec): Finds vulnerabilities, misconfigurations, and secrets in Terraform.
  - **Dockerfile Linting**: hadolint for checking Dockerfile best practices.
  - **Markdown Linting**: markdownlint for ensuring consistent Markdown formatting.
