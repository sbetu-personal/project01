resource "azurerm_resource_group" "servicebus" {
  name     = "${var.prefix}-servicebus-rg"
  location = var.location
}

resource "azurerm_servicebus_namespace" "servicebusnamespace" {
  name                = "${var.prefix}-servicebus-namespace"
  location            = azurerm_resource_group.servicebus.location
  resource_group_name = azurerm_resource_group.servicebus.name
  sku                 = "Standard"

  tags = {
    source = "terraform"
  }
}

resource "azurerm_servicebus_topic" "servicebustopic" {
  name         = "${var.prefix}-servicebus-topic"
  namespace_id = azurerm_servicebus_namespace.servicebusnamespace.id

  enable_partitioning = true
}