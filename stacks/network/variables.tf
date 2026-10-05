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