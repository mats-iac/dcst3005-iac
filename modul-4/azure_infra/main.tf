terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.2.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate-mats"
    storage_account_name = "sttfstatemats"
    container_name       = "tfstate"
    key                  = "dev/nettverk.tfstate"
    use_azuread_auth     = true
  }
}



provider "azurerm" {
  subscription_id = "a3adf20e-4966-4afb-b717-4de1baae6db1"
  features {

  }
}
resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.location
}

module "network" {
  source     = "./modules/network"
  rgname     = azurerm_resource_group.rg.name
  location   = var.location
  vnetname   = var.vnetname
  nsgname    = var.nsgname
  subnetname = var.subnetname
}

module "database" {
  source      = "./modules/database"
  rgname      = azurerm_resource_group.rg.name
  location    = var.location
  saname      = var.saname
  mssqlname   = var.mssqlname
  mssqldbname = var.mssqldbname

}

module "vmss" {
  source    = "./modules/vmss"
  rgname    = azurerm_resource_group.rg.name
  location  = var.location
  vmssname  = var.vmssname
  subnet_id = module.network.subnet_id
}