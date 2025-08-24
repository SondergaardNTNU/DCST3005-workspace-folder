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



resource "azurerm_resource_group" "shs-rg" {
  name     = var.resource_group_name # Use a unique name for the resource group, prefix or suffix with your initials tim-demo-rg-we / rg-demo-we-tim
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "shs-sa-demo" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.common_tags

}