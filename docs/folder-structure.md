# Folder Structure

The project is organized as follows:

```Shell
.
├── .devcontainer // Quick-start container
│   ├── python
│   └── terraform
├── .github // Configuration for GitHub repository
│   ├── ISSUE-TEMPLATE
│   └── WORKFLOW // A set of automated workflows
├── .vscode
├── assets
│   ├── diagrams // Diagrams-as-code
│   └── images
├── docs // documentation files related to the project
├── scripts
│   ├── aws
│   │   ├── lambda // Scripts to set up Lambda dependencies
│   │   └── sam // Scripts to test Lambda locally
│   ├── devcontainer // Scripts used by devcontainer
│   └── terraform // Scripts to start Terraform & HCP Terraform
├── src // Contains the source code for the Lambda function, dependencies, and SAM configuration
│   ├── events // Example event for SAM
├── terraform
│   ├── environments // Defines different environments (e.g., development, staging, production) with their respective Terraform configurations
│   │   └── dev
│   └── modules // Provides a space for organizing reusable Terraform modules.
│       └── lambda
└── tests // Upcoming
```
