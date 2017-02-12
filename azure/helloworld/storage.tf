resource "azurerm_storage_account" "helloworld" {
  name = "frecrahelloworld"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"
  location = "westeurope"
  account_type = "Standard_LRS"

  tags {
    environment = "HelloWorld"
  }
}

resource "azurerm_storage_container" "helloworld" {
  name = "helloworld"
  resource_group_name = "${azurerm_resource_group.helloworld.name}"
  storage_account_name = "${azurerm_storage_account.helloworld.name}"
  container_access_type = "private"
}