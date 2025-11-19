# Team 4 Job App - Terraform Infrastructure

Infrastructure as Code for Azure resources including Azure Key Vault for secrets management.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription with appropriate permissions

## Setup

### 1. Configure Azure Authentication

```bash
az login
az account set --subscription <SUBSCRIPTION_ID>
```

### 2. Create Terraform Variables File

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review and Apply

```bash
terraform plan
terraform apply
```

## GitHub Actions Pipeline

The repository includes an automated CI/CD pipeline (`.github/workflows/terraform-deploy.yml`) that:

- **On Pull Requests:** Runs `terraform plan` and comments results on the PR
- **On Push to Main:** Runs `terraform apply` to deploy changes

### Required GitHub Secrets

Set these in your GitHub repository settings (Settings → Secrets and variables → Actions):

- `AZURE_CLIENT_ID` - Azure service principal client ID
- `AZURE_CLIENT_SECRET` - Azure service principal client secret
- `AZURE_SUBSCRIPTION_ID` - Azure subscription ID
- `AZURE_TENANT_ID` - Azure tenant/directory ID

### Creating an Azure Service Principal

```bash
az ad sp create-for-rbac \
  --name "terraform-sp" \
  --role Contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID>
```

This will output the credentials needed for the GitHub secrets.

## Key Vault Management

### Adding Secrets

1. Deploy the infrastructure: `terraform apply`
2. Go to Azure Portal → Key Vault
3. Secrets → Generate/Import → Add your secrets

### Referencing Secrets in Container Apps

Use the Key Vault URI format in Container App environment variables:

```
@Microsoft.KeyVault(SecretUri=https://<vault-name>.vault.azure.net/secrets/<secret-name>/version)
```

## File Structure

- `main.tf` - Core infrastructure (Key Vault, Resource Group)
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `terraform.tfvars` - Local variable values (not in git)
- `.github/workflows/terraform-deploy.yml` - CI/CD pipeline

## Outputs

After applying, run:

```bash
terraform output
```

To view:
- Key Vault ID and URI
- Resource Group name and location

## Important Notes

- **Secrets are NOT defined in code** - manage them through Azure Portal only
- **Never commit `terraform.tfvars`** - it's in `.gitignore`
- The backend state is stored in the configured Azure Storage Account
