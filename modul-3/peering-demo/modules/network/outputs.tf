output "subnet_ids" {
  value       = { for k, s in azurerm_subnet.subnet : k => s.id }
  description = "Subnet-ID per subnettnavn"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Navnet på det virtuelle nettverket."
}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "Azure-ID-en til det virtuelle nettverket."
}