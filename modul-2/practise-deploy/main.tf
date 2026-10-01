terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.2.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "a3adf20e-4966-4afb-b717-4de1baae6db1"
  features {

  }
}




resource "azurerm_resource_group" "rg-sa" {
  name     = var.rgname
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "sa-demo" {
  name                     = var.saname
  resource_group_name      = azurerm_resource_group.rg-sa.name
  location                 = azurerm_resource_group.rg-sa.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = local.common_tags
}

output "said" {
  value = azurerm_storage_account.sa-demo.id
  
}