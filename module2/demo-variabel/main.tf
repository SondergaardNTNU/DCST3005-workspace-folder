terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
  subscription_id = "a3adf20e-4966-4afb-b717-4de1baae6db1" # Insert your Azure subscription ID between the quotes
}




resource "azurerm_resource_group" "rg-sa-shs" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "sa-shs" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg-sa-shs.name
  location                 = azurerm_resource_group.rg-sa-shs.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}