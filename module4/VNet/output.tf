output "rg_name_output" {
  value = azurerm_resource_group.resource_group.name
}

output "rg_location_output" {
  value = azurerm_resource_group.resource_group.location
}

output "vnet_location_output" {
  value = azurerm_virtual_network.virtual_network.location
}

output "vnet_name_output" {
  value = azurerm_virtual_network.virtual_network.name
}

output "subnet1_id_output" {
  value = azurerm_virtual_network.virtual_network.subnet[0].id
}

