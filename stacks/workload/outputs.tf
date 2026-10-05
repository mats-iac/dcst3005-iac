output "network_interface_id" {
  description = "ID of the network interface"
  value       = azurerm_network_interface.this.id
}

output "private_ip_address" {
  description = "Private IP address assigned to the network interface"
  value       = azurerm_network_interface.this.private_ip_address
}