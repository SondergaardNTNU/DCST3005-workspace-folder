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


resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

module "vnet" {
  source        = "./modules/VNet"
  vnet_name     = var.vnet_name
  rg_name       = azurerm_resource_group.rg.name
  location      = var.location
  address_space = var.address_space
  nsg_name      = var.nsg_name
  tags          = var.tags
}

module "subnet" {
  source           = "./modules/Subnet"
  subnet_name      = var.subnet_name
  vnet_name        = module.vnet.vnet_name
  vnet_rg          = module.vnet.vnet_rg
  address_prefixes = var.address_prefixes
  nsg_id           = module.vnet.nsg_id
}

module "vm" {
  source               = "./modules/VM"
  rg_name              = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  subnet_id            = module.subnet.subnet_id
  vm_size              = var.vm_size
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  caching              = var.caching
  storage_account_type = var.storage_account_type
  vm_image_sku         = var.vm_image_sku
  tags                 = var.tags
}