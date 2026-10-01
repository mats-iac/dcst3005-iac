resource "azurerm_resource_group" "example" {
  name     = format("rg-%s", var.base_name)
  location = var.location
}