
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_account_endpoint" {
  value = azurerm_storage_account.main.primary_blob_endpoint
}

output "environment" {
  value = var.env
}
