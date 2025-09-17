terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.43.0"
    }
  }
}



provider "azurerm" {
  features {}
  subscription_id = "a3adf20e-4966-4afb-b717-4de1baae6db1"
}


module "network" {
  source        = "../../modules/network"
  name_prefix   = var.name_prefix
  location      = var.location
  address_space = var.address_space
  subnet_prefix = var.subnet_prefix
}

module "compute" {
  source              = "../../modules/compute"
  name_prefix         = var.name_prefix
  location            = var.location
  subnet_id           = module.network.subnet_id
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_ssh_public_key= var.admin_ssh_public_key
}
