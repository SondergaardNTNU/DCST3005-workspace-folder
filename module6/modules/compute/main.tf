
terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.43.0"
    }
  }
}
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "${var.name_prefix}-public-ip"
  location            = var.location
  resource_group_name = "${var.name_prefix}-rg"
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  tags = {
    environment = var.name_prefix
    owner       = "Sondre H. Søndergaard"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.name_prefix}-nic"
  location            = var.location
  resource_group_name = "${var.name_prefix}-rg"
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
  tags = {
    environment = var.name_prefix
    owner       = "Sondre H. Søndergaard"
  }
}


locals {
  cloud_init = templatefile("${path.module}/cloud-init.tpl", {
    name_prefix = var.name_prefix
  })
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.name_prefix}-vm"
  location              = var.location
  resource_group_name   = "${var.name_prefix}-rg"
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }
  disable_password_authentication = true
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  custom_data = base64encode(local.cloud_init)
  tags = {
    environment = var.name_prefix
    owner       = "Sondre H. Søndergaard"
  }
}
