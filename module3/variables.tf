#variables.tf
variable "location" {
  type        = string
  description = "Deployment location"
  default     = "norwayeast"
}


variable "company" {
  type        = string
  description = "Company name"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "demo"
}

variable "costcenter" {
  type        = string
  description = "Billing code"
}

variable "nameprefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "suffix" {
  type        = string
  description = "Suffix for resource names"
}

variable "administrator_login" { #defined in terraform.tfvars
  type        = string
  description = "Administrator username for SQL Server"
}

variable "administrator_login_password" { #defined in terraform.tfvars
  type        = string
  description = "Administrator login password for SQL Server"
  sensitive   = true
}

variable "owner" {
  type        = string
  description = "value"
}
