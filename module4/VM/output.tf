output "vm_id" {
  description = "The ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_public_ip" {
  description = "The public IP address of the virtual machine"
  value       = azurerm_public_ip.vm_public_ip.ip_address
}

output "vm_admin_username" {
  description = "The admin username for the virtual machine"
  value       = var.admin_username
}

output "vm_admin_password" {
  description = "The admin password for the virtual machine"
  value       = var.admin_password
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = var.subnet_id
}
