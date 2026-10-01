terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.2.0"
    }
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = format("vnet-%s", var.vnet_name)
  location            = var.location
  resource_group_name = var.rg_name

  address_space = [var.address_space]
  tags          = var.tags
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = format("snet-%s", each.key)
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, each.value)]
}