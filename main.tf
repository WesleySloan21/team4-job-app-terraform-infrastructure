# main.tf

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-state-mgmt"
    storage_account_name = "aistatemgmt"
    container_name       = "terraform-tfstate-ai"
    key                  = "team4-infrastructure.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

# Get current Azure context
data "azurerm_client_config" "current" {}

# Create a resource group (container for all your Azure resources)
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Create Azure Key Vault for managing secrets
resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  enabled_for_disk_encryption = false
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7

  tags = var.tags
}

# Create access policy for current user/service principal
resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id       = azurerm_key_vault.main.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  secret_permissions = ["Get", "List", "Set", "Delete", "Purge"]

  depends_on = [azurerm_key_vault.main]
}

# Create access policy for Container App managed identity to read secrets
resource "azurerm_key_vault_access_policy" "container_app" {
  count              = var.create_container_app_access_policy ? 1 : 0
  key_vault_id       = azurerm_key_vault.main.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = var.container_app_identity_object_id
  secret_permissions = ["Get", "List"]

  depends_on = [azurerm_key_vault.main]
}

# Create Log Analytics workspace for Container App monitoring
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.environment_name != "" ? var.environment_name : "aca"}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# Create Container App Environment
resource "azurerm_container_app_environment" "main" {
  name                           = var.environment_name != "" ? var.environment_name : "aca-env"
  location                       = azurerm_resource_group.main.location
  resource_group_name            = azurerm_resource_group.main.name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.main.id

  tags = var.tags
}

# Create Container App (optional - only if container_app_name is provided)
resource "azurerm_container_app" "main" {
  count               = var.container_app_name != "" ? 1 : 0
  name                = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = var.container_app_name
      image  = var.container_image
      cpu    = var.cpu
      memory = var.memory
    }
    min_replicas = 1
    max_replicas = 1
  }

  ingress {
    external_enabled = true
    target_port      = var.container_port
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  tags = var.tags

  depends_on = [azurerm_container_app_environment.main]
}
