variable "location" {
  type        = string
  description = "Deployment location"
  default     = "West Europe"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
  default     = "shs-terraform-rg1"

}

variable "storage_account_name" {
  type        = string
  description = "Storage account name"
  default     = "shsdemostorage1"
}

variable "company" {
  type        = string
  description = "Company name"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "billing_code" {
  type        = string
  description = "Billing code"
}