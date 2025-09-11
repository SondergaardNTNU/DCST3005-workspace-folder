variable "subscription_id" {
  type        = string
  description = "Azure subscription ID for dette miljøet."
}

variable "environment" {
  type        = string
  description = "Navn på miljøet (f.eks. dev, test, prod)."
  
}

variable "name_prefix" {
  type        = string
  description = "Prefiks for ressurser i dette miljøet."
}

variable "location" {
  type        = string
  description = "Azure-region for ressursgruppen."
  default     = "Norway East"
  
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}