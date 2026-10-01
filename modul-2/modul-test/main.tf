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

module "ResourceGroup" {
  source    = "./ResourceGroup"
  base_name = "tf-demo"
  location  = "westeurope"
}

module "StorageAccount" {
  source    = "./StorageAccount"
  base_name = "TFdemo"
  rgname    = module.ResourceGroup.rg_name_output
  location  = "westeurope"
}