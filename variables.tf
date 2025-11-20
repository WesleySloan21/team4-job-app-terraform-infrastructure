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

variable "container_app_name" {
  description = "Name of the Container App"
  type        = string
  default     = ""
}

variable "container_image" {
  description = "Container image to deploy (e.g., mcr.microsoft.com/azuredocs/aca-helloworld:latest)"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/aca-helloworld:latest"
}

variable "container_port" {
  description = "Port that the container listens on"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "CPU cores for the container (e.g., 0.25, 0.5, 1.0)"
  type        = string
  default     = "0.25"
}

variable "memory" {
  description = "Memory for the container (e.g., 0.5Gi, 1Gi, 2Gi)"
  type        = string
  default     = "0.5Gi"
}
