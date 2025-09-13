#terraform init
#terraform plan -var-file="dev.terraform.tfvars"
#terraform apply -var-file="dev.terraform.tfvars"

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.43.0"
    }
  }
}


provider "azurerm" {
  subscription_id = var.subscription_id
  features {

  }
}

locals {
  rg_name = "rg-${var.environment}-${var.name_prefix}"
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}
