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
  vmssname  = var.vmssname
  subnet_id = module.network.subnet_id
  rgname    = var.rgname
  location  = var.location
}