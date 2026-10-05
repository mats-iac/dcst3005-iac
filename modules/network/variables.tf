variable "resource_group_name" {
  description = "Name of the resource group containing the network"
  type        = string
}

variable "location" {
  description = "Azure region where the network resources are created"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space used by the virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnet names to address prefixes"
  type        = map(string)
}