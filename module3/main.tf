terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "a3adf20e-4966-4afb-b717-4de1baae6db1"
  features {

  }
}

#main.tf
resource "azurerm_resource_group" "test" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_mssql_server" "test" {
  name                         = local.sql_server_name
  resource_group_name          = azurerm_resource_group.test.name
  location                     = azurerm_resource_group.test.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
}

resource "azurerm_mssql_database" "test" {
  name         = local.sql_database_name
  server_id    = azurerm_mssql_server.test.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"

  tags = local.common_tags

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}

output "azurerm_mssql_database" {
  value = azurerm_mssql_database.test.id
}