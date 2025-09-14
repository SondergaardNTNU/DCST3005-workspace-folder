#terraform init
#terraform plan -var-file="test.terraform.tfvars" -out=test-tfplan
#terraform apply "test-tfplan"

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.43.0"
    }
  }
}


provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}


module "stack" {
  source             = "../../Stack"
  rg_name            = azurerm_resource_group.rg.name
  location           = var.location
  environment        = var.environment
  name_prefix        = var.name_prefix
  vnet_cidr          = var.vnet_cidr
  subnet_cidr        = var.subnet_cidr
  tags               = var.tags
}