# Create a virtual network in the web_servers resource group
resource "azurerm_virtual_network" "network" {
  name                = "HelloWorldNetwork"
  address_space       = ["10.0.0.0/16"]
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"
}


resource "azurerm_subnet" "private1" {
  name           = "private1"
  address_prefix = "10.0.1.0/24"
  network_security_group_id = "${azurerm_network_security_group.private.id}"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
}

resource "azurerm_subnet" "public2" {
  name           = "public2"
  address_prefix = "10.0.2.0/24"
  network_security_group_id = "${azurerm_network_security_group.public.id}"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
}

resource "azurerm_subnet" "private3" {
  name           = "private3"
  address_prefix = "10.0.3.0/24"
  network_security_group_id = "${azurerm_network_security_group.private.id}"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
}

resource "azurerm_subnet" "public4" {
  name           = "public4"
  address_prefix = "10.0.4.0/24"
  network_security_group_id = "${azurerm_network_security_group.public.id}"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
}


resource "azurerm_network_security_group" "private" {
  name = "privatesubnetsecuritygroup"
  location = "westeurope"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"

  security_rule {
    name = "internalssh"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "22"
    destination_port_range = "22"
    source_address_prefix = "10.0.0.0/16"
    destination_address_prefix = "*"
  }


  security_rule {
    name = "lbhttp"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "tcp"
    source_port_range = "80"
    destination_port_range = "80"
    source_address_prefix = "${azurerm_public_ip.helloworld_public_ip.ip_address}"
    destination_address_prefix = "*"
  }

  tags {
    environment = "HelloWorldProduction"
  }
}

resource "azurerm_network_security_group" "public" {
  name = "publicsubnetsecuritygroup"
  location = "westeurope"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"

  security_rule {
    name = "publichhttp"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "80"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name = "publichssh"
    priority = 200
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "22"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "HelloWorldProduction"
  }
}

resource "azurerm_network_interface" "helloworld" {
  name = "helloworld"
  location = "West Europe"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"

  ip_configuration {
    name = "privateipconfig"
    subnet_id = "${azurerm_subnet.private1.id}"
    private_ip_address_allocation = "dynamic"
  }
}

