//Usage - Basic HTTP Trigger

resource "azurerm_resource_group" "functionrg" {
  name     = "${var.prefix}-function-rg"
  location = "West Europe"
}

resource "azurerm_storage_account" "funcstg" {
  name                     = "${var.prefix}functionstg"
  resource_group_name      = azurerm_resource_group.functionrg.name
  location                 = azurerm_resource_group.functionrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "sampleserviceplan" {
  name                = "${var.prefix}-service-plan"
  location            = azurerm_resource_group.functionrg.location
  resource_group_name = azurerm_resource_group.functionrg.name
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_function_app" "funcapp" {
  name                = "${var.prefix}-function-app"
  location            = azurerm_resource_group.functionrg.location
  resource_group_name = azurerm_resource_group.functionrg.name
  service_plan_id     = azurerm_service_plan.sampleserviceplan.id

  storage_account_name       = azurerm_storage_account.funcstg.name
  storage_account_access_key = azurerm_storage_account.funcstg.primary_access_key

  site_config {
    application_stack {
      python_version = "3.9"
    }
  }
}

resource "azurerm_function_app_function" "funcappfunc" {
  name            = "${var.prefix}-function-app-function"
  function_app_id = azurerm_linux_function_app.funcapp.id
  language        = "Python"
  test_data = jsonencode({
    "name" = "Azure"
  })
  config_json = jsonencode({
    "bindings" = [
      {
        "authLevel" = "function"
        "direction" = "in"
        "methods" = [
          "get",
          "post",
        ]
        "name" = "req"
        "type" = "httpTrigger"
      },
      {
        "direction" = "out"
        "name"      = "$return"
        "type"      = "http"
      },
    ]
  })
}