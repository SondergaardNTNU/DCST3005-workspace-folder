variable "location" {
  type        = string
  description = "Deployment location"
  default     = "West Europe"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
  default     = "shs-terraform-rg"

}

variable "storage_account_name" {
  type        = string
  description = "Storage account name"
  default     = "shsdemostorage"
}