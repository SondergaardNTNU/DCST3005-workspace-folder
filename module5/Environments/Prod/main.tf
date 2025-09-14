#terraform init
#terraform plan -var-file="prod.terraform.tfvars"
#terraform apply -var-file="prod.terraform.tfvars"

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

locals {
  rg_name = "rg-${var.environment}-${var.name_prefix}"
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}
