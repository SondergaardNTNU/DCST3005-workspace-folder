terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.39.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "a3adf20e-4966-4afb-b717-4de1baae6db1"
  features {

  }
}

resource "azurerm_resource_group" "shs-rg" {
  name     = "rg-demo-we-shs" # Use a unique name for the resource group, prefix or suffix with your initials tim-demo-rg-we / rg-demo-we-tim
  location = "West Europe"
}

resource "azurerm_storage_account" "shs-sa-demo" {
  name                     = "shsdemo"
  resource_group_name      = azurerm_resource_group.shs-rg.name
  location                 = azurerm_resource_group.shs-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}