resource "azurerm_resource_group" "rg" {
	name     = "${var.name_prefix}-rg"
	location = var.location
	tags = {
		environment = var.name_prefix
		owner       = "Sondre H. Søndergaard"
	}
}

resource "azurerm_virtual_network" "vnet" {
	name                = "${var.name_prefix}-vnet"
	address_space       = [var.address_space]
	location            = var.location
	resource_group_name = azurerm_resource_group.rg.name
	tags = {
		environment = var.name_prefix
		owner       = "Sondre H. Søndergaard"
	}
}

resource "azurerm_subnet" "subnet" {
	name                 = "${var.name_prefix}-subnet"
	resource_group_name  = azurerm_resource_group.rg.name
	virtual_network_name = azurerm_virtual_network.vnet.name
	address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_network_security_group" "nsg" {
	name                = "${var.name_prefix}-nsg"
	location            = var.location
	resource_group_name = azurerm_resource_group.rg.name
	tags = {
		environment = var.name_prefix
		owner       = "Sondre H. Søndergaard"
	}
}

resource "azurerm_network_security_rule" "allow_http" {
	name                        = "Allow-HTTP"
	priority                    = 100
	direction                   = "Inbound"
	access                      = "Allow"
	protocol                    = "Tcp"
	source_port_range           = "*"
	destination_port_range      = "80"
	source_address_prefix       = "*"
	destination_address_prefix  = "*"
	resource_group_name         = azurerm_resource_group.rg.name
	network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
	name                        = "Allow-SSH"
	priority                    = 110
	direction                   = "Inbound"
	access                      = "Allow"
	protocol                    = "Tcp"
	source_port_range           = "*"
	destination_port_range      = "22"
	source_address_prefix       = "109.108.217.167" # Replace with your public IP or use a variable
	destination_address_prefix  = "*"
	resource_group_name         = azurerm_resource_group.rg.name
	network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
	subnet_id                 = azurerm_subnet.subnet.id
	network_security_group_id = azurerm_network_security_group.nsg.id
}
