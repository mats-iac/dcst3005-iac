variable "nsgname" {
  description = "Network security group name"
  type        = string
  default     = "nsg-tf-demo"
}

variable "vnetname" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-tf-demo"
}

variable "subnetname" {
  description = "The name of the subnet"
  type = string
  default = "subnet-tf-demo"
}

variable "rgname" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-tf-demo"
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "westeurope"
}