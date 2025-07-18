resource "azurerm_public_ip" "vm" {
  count               = 1
  name                = "vm-pip-0"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "vm" {
  count               = var.vm_count
  name                = "vm-nic-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = count.index == 0 ? azurerm_public_ip.vm[0].id : null
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "vm-${format("%02d", count.index)}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  size                = "Standard_B1s"
  admin_username      = var.vm_admin_username
  network_interface_ids = [
    azurerm_network_interface.vm[count.index].id
  ]
  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file(var.public_ssh_key_path)
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk-vm-${count.index}"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = {
    Environment = "dev"
    Role        = "devops-task2"
    Function    = count.index == 0 ? "LoadBalancer" : "AppServer"
  }
}