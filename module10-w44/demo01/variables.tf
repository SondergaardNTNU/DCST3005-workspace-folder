variable "student_identifier" {
  description = "Unik studentidentifikator (brukernavn)"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment må være dev, test eller prod."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "norwayeast"

  validation {
    condition     = can(regex("^(norwayeast|norwaywest|westeurope|northeurope)$", var.location))
    error_message = "Location må være en av: norwayeast, norwaywest, westeurope, northeurope."
  }
}

variable "tags" {
  description = "Standard tags for alle ressurser"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Course      = "DCST3005"
    Environment = "dev"
    Owner       = "Sondre H. Søndergaard"
  }
}
