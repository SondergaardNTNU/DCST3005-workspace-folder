variable "rg_name" {
  type        = string
  description = "Navn på eksisterende Resource Group der nettverksressurser skal opprettes."
}

variable "location" {
  type        = string
  description = "Azure-region (må samsvare med RG)."
}

variable "environment" {
  type        = string
  description = "Miljønavn (dev, test, prod)."
}

variable "name_prefix" {
  type        = string
  description = "Navneprefix for nettverksressurser."
  default     = "demo"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Ekstra tags."
}

variable "sku_tier" {
  type        = string
  description = "The tier of the App Service Plan (e.g., Free, Shared, Basic, Standard, Premium)."
  default     = "Standard"
}

variable "sku_size" {
  type        = string
  description = "The size of the App Service Plan (e.g., F1, D1, B1, S1, P1v2)."
  default     = "S1"
}

variable "dotnet_framework_version" {
  type        = string
  description = "The .NET Framework version for the App Service (e.g., v4.0, v3.5)."
  default     = "v4.0"
  
}

variable "scm_type" {
    type        = string
    description = "The source control management type (e.g., None, LocalGit, GitHub)."
    default     = "LocalGit"
    }

variable "SOME_KEY" {
    type        = string
    description = "Example app setting key."
    default     = "some-value"
}

variable "connection_string" {
    type        = string
    description = "Example connection string."
    default     = "DefaultEndpointsProtocol=https;AccountName=your_account_name;AccountKey=your_account_key;EndpointSuffix=core.windows.net"
  
}