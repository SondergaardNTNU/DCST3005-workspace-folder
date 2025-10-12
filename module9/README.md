# Module9: Build Once, Deploy Many (Azure + Terraform)

## Overview
This module demonstrates a trunk-based, multi-environment Terraform solution for Azure, with CI/CD via GitHub Actions and remote state in Azure Storage.

## Structure
```
module9/
  buildOnce-deployMany/
    environments/         # Environment-specific tfvars
      dev.tfvars
      test.tfvars
      prod.tfvars
    scripts/              # Automation scripts
      build.sh
      deploy.sh
      cleanup.sh
    shared/               # Backend config
      backend.hcl
    terraform/            # Core Terraform code
      backend.tf
      main.tf
      outputs.tf
      variables.tf
      versions.tf
  .github/workflows/      # CI/CD workflows
    ci.yml
    cd.yml
```

## Prerequisites
- Azure subscription
- Resource Group, Storage Account, and Container for remote state
- GitHub repository with secrets set for Azure authentication

## Setup Steps
### 1. Bootstrap Backend Resources
Use the provided bootstrap script (see `backend-bootstrap/main.tf`) to create the Resource Group, Storage Account, and Container for remote state.

### 2. Configure GitHub Secrets
Add the following secrets to your GitHub repository:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_STORAGE_ACCOUNT`
- `AZURE_STORAGE_CONTAINER`

### 3. Protect Environments
- In GitHub, go to Settings > Environments and add `prod`.
- Set required reviewers for `prod` to prevent direct deployment.

### 4. Initialize Terraform
```sh
cd module9/buildOnce-deployMany/terraform
terraform init -backend-config=../shared/backend.hcl
```

### 5. Plan & Apply
For each environment:
```sh
terraform plan -var-file=../environments/dev.tfvars
terraform apply -var-file=../environments/dev.tfvars
```
Replace `dev.tfvars` with `test.tfvars` or `prod.tfvars` as needed.

### 6. Use Scripts
- `build.sh` – Validates and plans
- `deploy.sh` – Applies changes
- `cleanup.sh` – Destroys resources

### 7. CI/CD Workflows
- `ci.yml` runs on PRs for validation
- `cd.yml` deploys on merge to main, with environment protection for prod

## Troubleshooting
- Ensure backend resources exist before running Terraform.
- Check GitHub Actions logs for authentication or permission errors.

## References
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions for Terraform](https://github.com/hashicorp/setup-terraform)

---
For questions or issues, contact the repo maintainer.
