terraform {
  required_version = ">= 1.6.0"

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.40"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  resource_group_name = "rg-${var.name_prefix}-${var.environment}"
  vnet_name           = "vnet-${var.name_prefix}-${var.environment}"

  subnets = {
    "snet-web-${var.environment}"  = "10.0.1.0/24"
    "snet-app-${var.environment}"  = "10.0.2.0/24"
    "snet-data-${var.environment}" = "10.0.3.0/24"
  }
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
}

module "network" {
  source = "../../modules/network"

  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  vnet_name           = local.vnet_name
  vnet_address_space  = ["10.0.0.0/16"]
  subnets             = local.subnets
}