output "resource_group_name" {
  description = "Name of the network resource group"
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.network.vnet_id
}

output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value       = module.network.subnet_ids
}