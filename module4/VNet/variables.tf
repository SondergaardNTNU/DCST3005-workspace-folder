variable "base_name" {
  description = "The base name for resources"
  type        = string
}

variable "location" {
  description = "The location where resources will be created"
  default     = "norwayeast"
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_servers" {
  description = "The DNS servers for the virtual network"
  type        = list(string)
  default     = ["10.0.0.4", "10.0.0.5"]
}

variable "address_prefixes" {
  description = "The address prefixes for the subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
