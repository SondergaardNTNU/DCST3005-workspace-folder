resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "${var.environment}-${var.name_prefix}-appserviceplan"
  location            = var.location
  resource_group_name = var.rg_name
  kind                = var.kind
  reserved            = true

  sku {
    tier = var.sku_tier
    size = var.sku_size
  }
}

resource "azurerm_app_service" "app_service" {
  name                = "${var.environment}-${var.name_prefix}-app-service"
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = var.linux_fx_version
    scm_type         = var.scm_type
  }

  app_settings = {
    "SOME_KEY" = var.SOME_KEY
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_app_service.app_service.id
  subnet_id      = var.subnet_id
}