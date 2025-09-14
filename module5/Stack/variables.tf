variable "rg_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)."
}

variable "name_prefix" {
  type        = string
  description = "Prefix for resource names."
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources."
  default     = {}
}

variable "sku_tier" {
  type        = string
  description = "App Service Plan tier."
  default     = "Standard"
}

variable "sku_size" {
  type        = string
  description = "App Service Plan size."
  default     = "S1"
}

variable "dotnet_framework_version" {
  type        = string
  description = ".NET Framework version."
  default     = "v4.0"
}

variable "scm_type" {
  type        = string
  description = "Source control management type."
  default     = "LocalGit"
}

variable "SOME_KEY" {
  type        = string
  description = "Example app setting key."
  default     = "some-value"
}

variable "connection_string" {
  type        = string
  description = "Database connection string."
  default     = ""
}

variable "vnet_cidr" {
  type        = string
  description = "Virtual network CIDR."
  default     = "10.10.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "Subnet CIDR."
  default     = "10.10.1.0/24"
}

variable "allow_ssh_cidr" {
  type        = string
  description = "Allowed CIDR for SSH."
  default     = null
}

variable "linux_fx_version" {
    type        = string
    description = "The Linux FX version for the App Service (e.g., DOCKER|<image>)."
    default     = "DOCKER|mcr.microsoft.com/azure-app-service/samples/aspnetcore-helloworld:latest"
    }

variable "kind" {
    type        = string
    description = "The kind of App Service Plan (e.g., Windows, Linux)."
    default     = "Linux"
  
}
