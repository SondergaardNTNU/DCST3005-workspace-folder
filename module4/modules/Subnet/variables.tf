variable "subnet_name" { type = string }
variable "vnet_name" { type = string }
variable "vnet_rg" { type = string }
variable "address_prefixes" { type = list(string) }
variable "nsg_id" {
  description = "The ID of the Network Security Group to associate"
  type        = string
}
