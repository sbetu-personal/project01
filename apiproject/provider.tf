terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.7.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "sampleapp-terraform-rg"
    storage_account_name = "sampleapptfstg"
    container_name       = "state"
    key                  = "apim/terraform.tfstate"
  }
}