# Copy this file to terraform.tfvars and update values
resource_group_name = "team4-rg"
location            = "UK South"
key_vault_name      = "team4-job-app-key-vault"

# Container App Environment configuration
environment_name = "team4-aca-env"

tags = {
  environment = "dev"
  project     = "team4-job-app"
  managed_by  = "terraform"
}

