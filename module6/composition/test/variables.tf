
variable "name_prefix" { default = "shs-test" }
variable "location" { default = "norwayeast" }
variable "address_space" { default = "10.31.0.0/16" }
variable "subnet_prefix" { default = "10.31.1.0/24" }
variable "vm_size" { default = "Standard_B2s" }
variable "admin_username" { default = "" }
variable "admin_ssh_public_key" { default = "" }
variable "subscription_id" { default = "" }
