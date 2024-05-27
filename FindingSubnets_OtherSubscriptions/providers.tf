provider "azurerm" {
  features {}
}

terraform {
  required_version = "~> 1.5.7"

  required_providers {
    azurerm = {
      version = "~> 3.54.0"
      source  = "hashicorp/azurerm"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.13.1"
    }
  }
}

locals {
  account_id_dev = "797446e8-xxxx-xxxx-xxxx-11111111111"
  account_id_stg = "cfd60351-xxxx-xxxx-xxxx-22222222222"
  account_id_prd = "a8592e40-xxxx-xxxx-xxxx-33333333333"
}

provider "azapi" {
  alias                      = "dev"
  subscription_id            = local.account_id_dev
  skip_provider_registration = true
}
provider "azurerm" {
  alias                      = "dev"
  subscription_id            = local.account_id_dev
  skip_provider_registration = true
  features {}
}

provider "azapi" {
  alias                      = "stg"
  subscription_id            = local.account_id_stg
  skip_provider_registration = true
}
provider "azurerm" {
  alias                      = "stg"
  subscription_id            = local.account_id_stg
  skip_provider_registration = true
  features {}
}

provider "azapi" {
  alias                      = "prd"
  subscription_id            = local.account_id_prd
  skip_provider_registration = true
}
provider "azurerm" {
  alias                      = "prd"
  subscription_id            = local.account_id_prd
  skip_provider_registration = true
  features {}
}

# Find pod RGs - Dev
data "azapi_resource_list" "dev_pod_rgs" {
  provider               = azapi.dev
  type                   = "Microsoft.Resources/resourceGroups@2022-09-01"
  parent_id              = "/subscriptions/${local.account_id_dev}"
  response_export_values = ["*"]
}

# Find pod RGs - Stg
data "azapi_resource_list" "stg_pod_rgs" {
  provider               = azapi.stg
  type                   = "Microsoft.Resources/resourceGroups@2022-09-01"
  parent_id              = "/subscriptions/${local.account_id_stg}"
  response_export_values = ["*"]
}

# Find pod RGs - Prd
data "azapi_resource_list" "prd_pod_rgs" {
  provider               = azapi.prd
  type                   = "Microsoft.Resources/resourceGroups@2022-09-01"
  parent_id              = "/subscriptions/${local.account_id_prd}"
  response_export_values = ["*"]
}