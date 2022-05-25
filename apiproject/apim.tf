resource "azurerm_resource_group" "apimrg" {
  name     = "${var.prefix}-apim-rg"
  location = var.location
}

resource "azurerm_api_management" "apim" {
  name                = "${var.prefix}-apim"
  location            = azurerm_resource_group.apimrg.location
  resource_group_name = azurerm_resource_group.apimrg.name
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"

  sku_name = "Premium_1"

  virtual_network_type = "Internal"

  virtual_network_configuration {
    subnet_id = azurerm_subnet.sample_api_management.id
  }

}

# Create Application Insights
resource "azurerm_application_insights" "apim-ai" {
  name                = "${var.prefix}-ai"
  resource_group_name = azurerm_resource_group.apimrg.name
  location            = var.location
  application_type    = "web"

}

# Create Logger
resource "azurerm_api_management_logger" "apim-logger" {
  name                = "${var.prefix}-apim-logger"
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.apimrg.name

  application_insights {
    instrumentation_key = azurerm_application_insights.apim-ai.instrumentation_key
  }
}

resource "azurerm_subnet" "sample_api_management" {
  name                 = "${var.prefix}-apim-subnet"
  resource_group_name  = var.virtual_network_resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.x.x.0/27"]
}

resource "azurerm_storage_account" "apim" {
  name                     = "${var.prefix}apimstg"
  resource_group_name      = azurerm_resource_group.apimrg.name
  location                 = azurerm_resource_group.apimrg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
