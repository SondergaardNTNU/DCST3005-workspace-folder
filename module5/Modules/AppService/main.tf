resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "${var.environment}-${var.name_prefix}-appserviceplan"
  location            = var.location
  resource_group_name = var.rg_name

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
    dotnet_framework_version = var.dotnet_framework_version
    scm_type                 = var.scm_type
  }

  app_settings = {
    "SOME_KEY" = var.SOME_KEY
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}