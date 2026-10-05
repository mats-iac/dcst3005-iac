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
  nic_name = "nic-${var.name_prefix}-${var.environment}"
}

data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = "env/${var.environment}/network.tfstate"
    use_azuread_auth     = true
  }
}

resource "azurerm_network_interface" "this" {
  name                = local.nic_name
  location            = var.location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.terraform_remote_state.network.outputs.subnet_ids["snet-app-${var.environment}"]
    private_ip_address_allocation = "Dynamic"
  }
}