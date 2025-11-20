# Copy this file to terraform.tfvars and update values
resource_group_name = "team4-rg"
location            = "UK South"
key_vault_name      = "team4-job-app-key-vault"

# Container App configuration
environment_name   = "team4-aca-env"
container_app_name = "team4-job-app"
container_image    = "mcr.microsoft.com/azuredocs/aca-helloworld:latest"
container_port     = 80
cpu                = "0.25"
memory             = "0.5Gi"

tags = {
  environment = "production"
  project     = "team4-job-app"
  managed_by  = "terraform"
}

