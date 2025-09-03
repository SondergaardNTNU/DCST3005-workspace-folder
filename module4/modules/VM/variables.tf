variable "nic_name" {
  description = "The name of the network interface"
  type        = string
  default     = "shs-nic"
}

variable "rg_name" {
  description = "The name of the resource group"
  type        = string
  default     = "shs-rg"
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
  default     = "shs-vm"
}

variable "location" {
  description = "The location where resources will be created"
  default     = "norwayeast"

}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_DS1_v2"
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
  default     = ""
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