variable "resource_group_name" { default = "kubernetes-tp" }
variable "location" { default = "francecentral" }
variable "vnet_subnet_id" {default = "azurerm_subnet.mohamed.id"}
variable "nsg_id" {default = "azurerm_network_security_group.mohamed.id"}
variable "vm_count" { default = "3"}
variable "vm_size" {default = "Standard_D2ds_v4"}
variable "vm_image" {default = "Canonical:UbuntuServer:22.04-LTS:latest"}

resource "azurerm_linux_virtual_machine" "mohamed" {
  count                = var.vm_count
  name                 = "mohamed-vm-${count.index}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  size                 = var.vm_size
  admin_username       = "mohamed"
  network_interface_ids = [azurerm_network_interface.mohamed[count.index].id]
  admin_ssh_key {
    username       = "mohamed"
    public_key     = file("~/.ssh/id_rsa.pub")
    disable_password_authentication = true
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "mohamed" {
  count               = var.vm_count
  name                = "my-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "my-nic-ipconfig"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "mohamed" {
  count                        = var.vm_count
  network_interface_id         = azurerm_network_interface.mohamed[count.index].id
  network_security_group_id    = var.nsg_id
}

output "vm_ids" {
  value = azurerm_linux_virtual_machine.mohamed[*].id
}
