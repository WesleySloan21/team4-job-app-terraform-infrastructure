output "key_vault_id" {
  description = "ID of the Azure Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_uri" {
  description = "URI of the Azure Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "key_vault_name" {
  description = "Name of the Azure Key Vault"
  value       = azurerm_key_vault.main.name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Container App Environment outputs
output "container_app_environment_id" {
  description = "ID of the Container App Environment"
  value       = azurerm_container_app_environment.main.id
}

output "container_app_environment_name" {
  description = "Name of the Container App Environment"
  value       = azurerm_container_app_environment.main.name
}

output "container_app_environment_static_ip" {
  description = "Static IP of the Container App Environment"
  value       = azurerm_container_app_environment.main.static_ip_address
}

# Container App outputs (if created)
output "container_app_id" {
  description = "ID of the Container App"
  value       = try(azurerm_container_app.main[0].id, "")
}

output "container_app_url" {
  description = "Public URL of the Container App"
  value       = try(azurerm_container_app.main[0].ingress[0].fqdn, "")
}

# Log Analytics outputs
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.id
}
