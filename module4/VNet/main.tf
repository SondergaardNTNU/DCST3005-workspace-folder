resource "azurerm_resource_group" "resource_group" {
  name     = "${var.base_name}-rg"
  location = var.location
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = "${var.base_name}-nsg"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.base_name}-vnet"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = [var.address_space]
  dns_servers         = [for dns in var.dns_servers : dns]

  subnet {
    name             = "${var.base_name}-subnet1"
    address_prefixes = [var.address_prefixes[0]]
    security_group   = azurerm_network_security_group.network_security_group.id
  }

  subnet {
    name             = "${var.base_name}-subnet2"
    address_prefixes = [var.address_prefixes[1]]
    security_group   = azurerm_network_security_group.network_security_group.id
  }
}