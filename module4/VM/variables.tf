variable "base_name" {
  description = "The name of the storage account"
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location where resources will be created"
  default     = "norwayeast"

}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
  sensitive   = true
}

variable "caching" {
  description = "The caching type for the OS disk"
  type        = string
  default     = "ReadWrite"
}

variable "storage_account_type" {
  description = "The storage account type for the OS disk"
  type        = string
  default     = "Standard_LRS"
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}
