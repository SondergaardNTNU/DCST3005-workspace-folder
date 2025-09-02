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

module "vnet" {
  source    = "./VNet"
  base_name = var.base-name
  location  = var.location
}

module "vm" {
  source         = "./VM"
  base_name      = var.base-name
  rg_name        = module.vnet.rg_name_output
  location       = module.vnet.location
  vm_size        = var.vm_size
  admin_username = var.admin_username
  admin_password = var.admin_password
  subnet_id      = module.vnet.subnet_id
}