variable "nsg_name" {
  description = "The name of the network security group"
  type        = string
  default     = "shs-nsg"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "shs-vnet"
}

variable "rg_name" {
  description = "The name of the resource group"
  type        = string
  default     = "shs-rg"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "subnet1"
}

variable "location" {
  description = "The location where resources will be created"
  default     = "norwayeast"
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "address_prefixes" {
  description = "The address prefixes for the subnets"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}
