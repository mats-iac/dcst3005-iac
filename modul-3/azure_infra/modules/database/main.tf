resource "azurerm_storage_account" "sa" {
  name                     = var.saname
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "mssqlserver" {
  name                         = var.mssqlname
  resource_group_name          = var.rgname
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = vaar.admin_password
}

resource "azurerm_mssql_database" "mssqldbname" {
  name           = var.mssqldbname
  server_id      = azurerm_mssql_server.mssqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false


  lifecycle {
    prevent_destroy = false
  }
}
