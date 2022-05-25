resource "azurerm_resource_group" "samplerg" {
  name     = "sample-resources-rg"
  location = "West Europe"
}

data "azurerm_virtual_network" "samplenw" {
  name                = var.virtual_network_name
  resource_group_name = var.virtual_network_resource_group_name
}

data "azurerm_subnet" "samplesubnet" {
  name                 = var.subnet
  resource_group_name  = var.virtual_network_resource_group_name
  virtual_network_name = var.virtual_network_name

}

resource "azurerm_network_interface" "sampleni" {
  name                = "sample-nic"
  location            = azurerm_resource_group.samplerg.location
  resource_group_name = azurerm_resource_group.samplerg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.samplesubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "samplevm" {
  name                = "sample-machine"
  resource_group_name = azurerm_resource_group.samplerg.name
  location            = azurerm_resource_group.samplerg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.sampleni.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}