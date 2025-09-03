variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "norwayeast"
}

variable "rg_name" {
  description = "Resource group name"
  type        = string
  default     = "shs-rg"
}

variable "nsg_name" {
  description = "Network Security Group name"
  type        = string
  default     = "shs-nsg"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "subnet1"
}

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
  default     = "shs-vnet"
}

variable "vm_name" {
  description = "Virtual Machine name"
  type        = string
  default     = "shs-vm"
}

variable "vm_size" {
  description = "Virtual Machine size"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "address_prefixes" {
  description = "Address prefixes for the subnet(s)"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "shs-admin"
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
  default     = "P@ssw0rd!"
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

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "vm_image_sku" {
  description = "The SKU of the VM image"
  type        = string
  default     = "22_04-lts"
}