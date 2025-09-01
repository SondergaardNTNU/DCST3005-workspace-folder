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

module "ResourceGroup" {
  source    = "./ResourceGroup"
  base_name = "shs-demo"
  location  = "West Europe"
}

module "StorageAccount" {
  source    = "./StorageAccount"
  base_name = "shs-demo"
  rg_name   = module.ResourceGroup.rg_name_output
  location  = module.ResourceGroup.location_output
}