variable "resource_group_name" {default = "kubernetes-tp"}
variable "location" {default = "francecentral"}
variable "vnet_cidr" {default = "10.244.0.0/16"}
variable "subnet_cidr" {default = "10.244.0.0/24"}

resource "azurerm_virtual_network" "mohamed" {
  name                = "my-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "mohamed" {
  name                 = "my-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.mohamed.name
  address_prefixes     = [var.subnet_cidr]
}

output "vnet_id" {
  value = azurerm_virtual_network.mohamed.id
}

output "subnet_id" {
  value = azurerm_subnet.mohamed.id
}
