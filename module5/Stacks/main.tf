module "app_service" {
  source = "../Modules/AppService"

  rg_name                = azurerm_resource_group.rg_name
  location               = var.location
  environment            = var.environment
  name_prefix            = var.name_prefix
  tags                   = var.tags
  sku_tier               = var.sku_tier
  sku_size               = var.sku_size
  dotnet_framework_version = var.dotnet_framework_version
  scm_type               = var.scm_type
  SOME_KEY               = var.SOME_KEY
  connection_string      = var.connection_string
}

module "network" {
  source = "../Modules/Network"

  rg_name         = azurerm_resource_group.rg_name
  location        = var.location
  environment     = var.environment
  name_prefix     = var.name_prefix
  vnet_cidr       = var.vnet_cidr
  subnet_cidr     = var.subnet_cidr
  allow_ssh_cidr  = var.allow_ssh_cidr
  tags            = var.tags
}
