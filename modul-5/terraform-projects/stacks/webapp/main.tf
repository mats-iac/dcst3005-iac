terraform {
  required_version = ">= 1.15.0"

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.40.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_service_plan" "plan" {
  #checkov:skip=CKV_AZURE_211:Studentmiljoe med begrenset budsjett; produksjonsplan er ikke paakrevd
  #checkov:skip=CKV_AZURE_212:Flere instanser gir ekstra kostnader og er ikke paakrevd i studentmiljoe
  #checkov:skip=CKV_AZURE_225:Zone redundancy er ikke paakrevd i studentmiljoe og oeker kostnadene
  name                = "${var.app_name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = var.sku
  tags                = var.tags
}


# Auto-healing er ikke konfigurert for denne enkle student-webappen.
# Dette vurderes på nytt dersom applikasjonen skal brukes i produksjon.
resource "azurerm_linux_web_app" "app" { # tflint-ignore: azurerm_app_service_missing_auto_heal_setting
  #checkov:skip=CKV_AZURE_13:Offentlig studentdemo skal kunne vises uten innlogging; ingen sensitive data eksponeres
  #checkov:skip=CKV_AZURE_17:Studentdemoen bruker ikke gjensidig TLS eller klientsertifikater
  #checkov:skip=CKV_AZURE_222:Offentlig tilgang er nødvendig for aa demonstrere webappen i studentprosjektet
  #checkov:skip=CKV_AZURE_88:Node.js-demoen bruker ikke Azure Files og trenger ingen separat filtilkobling
  name                = var.app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }

  site_config {
    ftps_state                        = "Disabled"
    http2_enabled                     = true
    health_check_path                 = "/"
    health_check_eviction_time_in_min = 10

    application_stack {
      node_version = var.node_version
    }
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }

  app_settings = var.app_settings
}

# siste test med cleanup timer i workflow