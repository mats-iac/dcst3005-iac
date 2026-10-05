variable "subscription_id" {
  description = "Azure subscription ID used for deployment"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "test"], var.environment)
    error_message = "Environment must be dev or test."
  }
}

variable "location" {
  description = "Azure region where resources are deployed"
  type        = string
  default     = "westeurope"
}

variable "name_prefix" {
  description = "Short prefix used when naming Azure resources"
  type        = string
}

variable "backend_resource_group_name" {
  description = "Resource group containing the Terraform state storage account"
  type        = string
}

variable "backend_storage_account_name" {
  description = "Storage account containing Terraform state"
  type        = string
}

variable "backend_container_name" {
  description = "Storage container containing Terraform state"
  type        = string
  default     = "tfstate"
}