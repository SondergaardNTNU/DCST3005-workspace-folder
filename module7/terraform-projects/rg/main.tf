terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.40.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "fd-rg" {
  name     = var.rg_name
  location = var.rg_location
}