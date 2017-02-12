resource "azurerm_dns_zone" "zone1" {
  name = "azure.frecra.com"
  resource_group_name = "dns"
}

resource "azurerm_dns_a_record" "helloworld" {
  name = "helloworld"
  zone_name = "${azurerm_dns_zone.zone1.name}"
  resource_group_name = "dns"
  ttl = "300"
  records = ["${azurerm_public_ip.helloworld_public_ip.ip_address}"]
}
