variable "base-name" {
  description = "The base name for resources"
  type        = string
}

variable "location" {
  description = "The location where resources will be created"
  type        = string
  default     = "norwayeast"
}

variable "rg_name" {
  description = "The name of the resource group"
  type        = string
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
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}
