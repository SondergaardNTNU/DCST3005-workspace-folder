module "app_service" {
  source = "../Modules/AppService"

  rg_name          = var.rg_name
  location         = var.location
  environment      = var.environment
  name_prefix      = var.name_prefix
  tags             = var.tags
  sku_tier         = var.sku_tier
  sku_size         = var.sku_size
  kind             = var.kind
  scm_type         = var.scm_type
  SOME_KEY         = var.SOME_KEY
  linux_fx_version = var.linux_fx_version
  subnet_id        = module.network.subnet_id
}

module "network" {
  source = "../Modules/Network"

  rg_name     = var.rg_name
  location    = var.location
  environment = var.environment
  name_prefix = var.name_prefix
  vnet_cidr   = var.vnet_cidr
  subnet_cidr = var.subnet_cidr
  tags        = var.tags
}
