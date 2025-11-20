variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "key_vault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,24}$", var.key_vault_name))
    error_message = "Key Vault name must be 3-24 characters and contain only alphanumeric characters and hyphens."
  }
}

variable "create_container_app_access_policy" {
  description = "Whether to create an access policy for Container App managed identity"
  type        = bool
  default     = false
}

variable "container_app_identity_object_id" {
  description = "Object ID of the Container App managed identity (required if create_container_app_access_policy is true)"
  type        = string
  default     = ""
}

variable "environment_name" {
  description = "Name of the Container App Environment"
  type        = string
  default     = ""
}
