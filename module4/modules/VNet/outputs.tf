output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
output "vnet_rg" {
  value = azurerm_virtual_network.vnet.resource_group_name
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}