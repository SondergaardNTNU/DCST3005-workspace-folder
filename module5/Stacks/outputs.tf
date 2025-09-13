output "app_service_id" {
  description = "ID of the App Service resource."
  value       = module.app_service.app_service_id
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service."
  value       = module.app_service.default_hostname
}

output "network_subnet_id" {
  description = "ID of the subnet created by the network module."
  value       = module.network.subnet_id
}

output "network_vnet_name" {
  description = "Name of the VNet created by the network module."
  value       = module.network.vnet_name
}
