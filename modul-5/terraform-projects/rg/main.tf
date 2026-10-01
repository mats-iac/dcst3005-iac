terraform {
  required_version = ">= 1.16.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.4"
    }
  }
}

provider "azurerm" {
  features {}

  resource_providers_to_register = ["Microsoft.Storage"]
}

resource "azurerm_resource_group" "fd-rg" {
  name     = "rg-workflow-demo-mats"
  location = "West Europe"
}