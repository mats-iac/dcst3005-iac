variable "location" {
  type        = string
  description = "Deployment location"
  default     = "West Europe"
}

variable "rgname" {
  type        = string
  description = "Resource group name"
  default     = "rg-demo-terraform"
}

variable "base_name" {
  type        = string
  description = "Storage Account name"
}