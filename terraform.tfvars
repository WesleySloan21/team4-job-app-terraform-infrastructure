# Copy this file to terraform.tfvars and update values
resource_group_name = "team4-rg"
location            = "UK South"
key_vault_name      = "team4-kv"

tags = {
  environment = "production"
  project     = "team4-job-app"
  managed_by  = "terraform"
}

