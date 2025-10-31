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

variable "vnet_cidr" {
  type        = string
  description = "CIDR-blokk for det virtuelle nettverket."
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR-blokk for subnettet."
  default     = "10.0.1.0/24"
}






