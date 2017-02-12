resource "azurerm_virtual_machine" "helloworld" {
  name = "helloworld"
  availability_set_id = "${azurerm_availability_set.helloworld.id}"
  location = "West Europe"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"
  network_interface_ids = [
    "${azurerm_network_interface.helloworld.id}"]
  vm_size = "Standard_A0"

  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.10"
    version = "latest"
  }

  storage_os_disk {
    name = "myosdisk1"
    vhd_uri = "${azurerm_storage_account.helloworld.primary_blob_endpoint}${azurerm_storage_container.helloworld.name}/myosdisk1.vhd"
    caching = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name = "helloworldserver"
    admin_username = "frecraadmin"
    admin_password = "thisisnotused001!"
    custom_data = "${base64encode(file("userdata.yml"))}"
  }



  os_profile_linux_config {
    disable_password_authentication = true
    "ssh_keys" {
      path = "/home/frecraadmin/.ssh/authorized_keys"
      key_data = "${file("azure_eu.pub")}"
    }
  }

  tags {
    environment = "HelloWorldProduction"
  }
}

resource "azurerm_availability_set" "helloworld" {
  name = "helloworld_availabilty_set"
  location = "West Europe"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"

  tags {
    environment = "HelloWorldProduction"
  }
}