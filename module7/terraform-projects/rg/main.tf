terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.40.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "a3adf20e-4966-4afb-b717-4de1baae6db1"
  features {

  }
}

resource "azurerm_resource_group" "fd-rg" {
  name     = "rg-demo-shs"
  location = "West Europe"
}