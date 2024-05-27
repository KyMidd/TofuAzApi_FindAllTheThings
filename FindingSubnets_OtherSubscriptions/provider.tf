# provider "azurerm" {
#   features {}
# }

# terraform {
#   required_version = "~> 1.5.7"

#   required_providers {
#     azurerm = {
#       version = "~> 3.54.0"
#       source  = "hashicorp/azurerm"
#     }
#     azapi = {
#       source = "Azure/azapi"
#     }
#   }
# }

# provider "azapi" {
#   alias                      = "dev"
#   subscription_id            = "797446e8-xxxx-xxxx-xxxx-1111111111"
#   skip_provider_registration = true
# }
# provider "azurerm" {
#   alias                      = "dev"
#   subscription_id            = "797446e8-xxxx-xxxx-xxxx-1111111111"
#   skip_provider_registration = true
#   features {}
# }

# provider "azapi" {
#   alias                      = "stg"
#   subscription_id            = "cfd60351-xxxx-xxxx-xxxx-222222222"
#   skip_provider_registration = true
# }
# provider "azurerm" {
#   alias                      = "stg"
#   subscription_id            = "cfd60351-xxxx-xxxx-xxxx-222222222"
#   skip_provider_registration = true
#   features {}
# }

# provider "azapi" {
#   alias                      = "prd"
#   subscription_id            = "a8592e40-xxxx-xxxx-xxxx-333333333333"
#   skip_provider_registration = true
# }
# provider "azurerm" {
#   alias                      = "prd"
#   subscription_id            = "a8592e40-xxxx-xxxx-xxxx-333333333333"
#   skip_provider_registration = true
#   features {}
# }