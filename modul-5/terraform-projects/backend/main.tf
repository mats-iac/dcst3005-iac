terraform {
  required_version = ">= 1.6.0"

  backend "azurerm" {
    # see backend.hcl for non-secret settings
    # use_azuread_auth = true  # uncomment to use Azure AD auth (instead of access key)
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  use_cli         = true
}

# Logged-in context (user/service principal via az login)
data "azurerm_client_config" "current" {}

# If suffix is empty, create a short random to help uniqueness
resource "random_string" "auto_suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
  keepers = {
    prefix = var.name_prefix
  }
  count = var.unique_suffix == "" ? 1 : 0
}

# When unique_suffix not provided, use random
locals {
  effective_suffix = var.unique_suffix != "" ? var.unique_suffix : (length(random_string.auto_suffix) == 1 ? random_string.auto_suffix[0].result : "")
  final_suffix     = local.effective_suffix
  # Recompute names when auto suffix exists
  rg_final = var.resource_group_name != "" ? var.resource_group_name : (
    local.final_suffix != "" ? "rg-${var.name_prefix}-${local.final_suffix}" : "rg-${var.name_prefix}"
  )
  sa_final = var.storage_account_name != "" ? var.storage_account_name : (
    local.final_suffix != "" ? "st${var.name_prefix}${local.final_suffix}" : "st${var.name_prefix}"
  )
  kv_final = var.kv_name != "" ? var.kv_name : (
    local.final_suffix != "" ? "kv-${var.name_prefix}-${local.final_suffix}" : "kv-${var.name_prefix}"
  )
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_final
  location = var.location
  tags     = var.tags
}

# Storage Account for Terraform state
resource "azurerm_storage_account" "sa" {
  #checkov:skip=CKV_AZURE_206:LRS er valgt for lavere kostnader i studentmiljoet; versjonering og soft delete er aktivert
  #checkov:skip=CKV_AZURE_59:GitHub-hostede runnere trenger nettverkstilgang til Terraform state; offentlig blob-tilgang er deaktivert
  #checkov:skip=CKV_AZURE_33:Storage-kontoen brukes til Terraform state og ikke Azure Queue
  #checkov:skip=CKV_AZURE_206:LRS er valgt for lavere kostnader i studentmiljoet; versjonering og soft delete er aktivert
  #checkov:skip=CKV2_AZURE_40:Shared Key beholdes midlertidig for bootstrap-kompatibilitet; GitHub Actions bruker Entra ID
  #checkov:skip=CKV2_AZURE_33:Privat endepunkt krever nettverkstilknytning som ikke inngaar i studentoppsettet
  #checkov:skip=CKV2_AZURE_41:SAS-utloepspolicy er ikke konfigurert i studentoppsettet; Entra ID brukes for Terraform state
  #checkov:skip=CKV2_AZURE_1:Azure bruker plattformadministrert kryptering; egen noekkel er ikke paakrevd i studentoppsettet
  name                     = local.sa_final
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Hardening / good practice
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  # shared_access_key_enabled = false <-- Set to false after bootstrap
  shared_access_key_enabled       = true # tillat nøkler ved bootstrap
  https_traffic_only_enabled      = true
  default_to_oauth_authentication = true

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 14
    }
    container_delete_retention_policy {
      days = 14
    }
    change_feed_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

# Private container for state
resource "azurerm_storage_container" "state" {
  #checkov:skip=CKV2_AZURE_21:Leselogging av state er ikke konfigurert i studentoppsettet; redusert sporbarhet aksepteres
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

# Key Vault (RBAC-enabled)
resource "azurerm_key_vault" "kv" {
  #checkov:skip=CKV_AZURE_189:GitHub-hostede runnere trenger nettverkstilgang til Key Vault i studentmiljoet
  #checkov:skip=CKV_AZURE_109:Brannmurbegrensninger er ikke konfigurert fordi GitHub-runnerne benytter dynamiske IP-adresser
  #checkov:skip=CKV2_AZURE_32:Private endpoint krever privat nettverkstilknytning som ikke inngaar i studentoppsettet
  #checkov:skip=CKV2_AZURE_40:Shared Key beholdes midlertidig for bootstrap-kompatibilitet; GitHub Actions bruker Entra ID og OIDC
  name                       = local.kv_final
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.kv_sku_name
  soft_delete_retention_days = 90
  purge_protection_enabled   = true
  enable_rbac_authorization  = true

  # Network rules can be tightened later in exercises
  public_network_access_enabled = true

  tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

# --------- RBAC ASSIGNMENTS ---------
# Storage: give principals Blob Data Contributor on the *container* (scope must be container or SA).
resource "azurerm_role_assignment" "sa_blob_contributor" {
  for_each             = local.principals
  scope                = azurerm_storage_account.sa.id # for container, use azurerm_storage_container.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.key
  depends_on           = [azurerm_storage_container.state]
}

# (Optional) SA Reader at account scope for portal listing (nice-to-have)
resource "azurerm_role_assignment" "sa_reader" {
  for_each             = local.principals
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Reader"
  principal_id         = each.key
  depends_on           = [azurerm_storage_account.sa]
}

# Key Vault: grant Secrets Officer (read/write). Use Secrets User if read-only is preferred.
resource "azurerm_role_assignment" "kv_secrets_officer" {
  for_each             = local.principals
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.key
  depends_on           = [azurerm_key_vault.kv]
}
