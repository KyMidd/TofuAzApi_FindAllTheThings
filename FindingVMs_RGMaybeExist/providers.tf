provider "azurerm" {
  features {}
}

provider "azapi" {
  skip_provider_registration = true
}

terraform {
  required_version = "~> 1.5.7"

  required_providers {
    azurerm = {
      version = "~> 3.78.0"
      source  = "hashicorp/azurerm"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.13.1"
    }
  }
}
