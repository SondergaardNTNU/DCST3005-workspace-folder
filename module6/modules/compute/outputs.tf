output "public_ip_address" { value = azurerm_public_ip.vm_public_ip.ip_address }
output "nginx_url" { value = "http://${azurerm_public_ip.vm_public_ip.ip_address}" }
