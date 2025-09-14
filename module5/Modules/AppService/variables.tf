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
  default     = "Free"
}

variable "sku_size" {
  type        = string
  description = "The size of the App Service Plan (e.g., F1, D1, B1, S1, P1v2)."
  default     = "F1"
}

variable "kind" {
    type        = string
    description = "The kind of App Service Plan (e.g., Windows, Linux)."
    default     = "Linux"
    }

variable "linux_fx_version" {
    type        = string
    description = "The Linux FX version for the App Service (e.g., DOCKER|<image>)."
    default     = "DOCKER|mcr.microsoft.com/azure-app-service/samples/aspnetcore-helloworld:latest"
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


variable "subnet_id" {
  type        = string
  description = "ID til subnettet som skal brukes for VNet-integrasjon med App Service."
}