resource "azurerm_resource_group" "example" {
  name     = "${var.base_name}-rg"
  location = var.location
}