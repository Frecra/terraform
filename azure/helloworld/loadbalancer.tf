resource "azurerm_public_ip" "helloworld_public_ip" {
  name = "PublicIPForLB"
  location = "West Europe"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_lb" "helloworldlb" {
  name = "HelloWorldPublicLoadBalancer"
  location = "West Europe"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"

  frontend_ip_configuration {
    name = "HelloWorldLBIPAddress"
    public_ip_address_id = "${azurerm_public_ip.helloworld_public_ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "helloworld_backend_pool" {
  resource_group_name = "${azurerm_resource_group.helloworld.name}"
  loadbalancer_id = "${azurerm_lb.helloworldlb.id}"
  name = "BackEndAddressPool"
  location = ""


}

resource "azurerm_lb_probe" "helloworld" {
  location = "West Europe"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"
  loadbalancer_id = "${azurerm_lb.helloworldlb.id}"
  name = "http_probe"
  port = 80
}

//check if we can put in refer for frontend_ip_configuration_name
resource "azurerm_lb_rule" "test" {
  location = "West Europe"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"
  loadbalancer_id = "${azurerm_lb.helloworldlb.id}"
  name = "LBRule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = "HelloWorldLBIPAddress"
}