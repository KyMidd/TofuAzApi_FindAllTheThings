# Find RGs - Dev
data "azapi_resource_list" "dev_rgs" {
  provider               = azapi.dev
  type                   = "Microsoft.Resources/resourceGroups@2022-09-01"
  parent_id              = "/subscriptions/${local.account_id_dev}"
  response_export_values = ["*"]
}

# Find RGs - Stg
data "azapi_resource_list" "stg_rgs" {
  provider               = azapi.stg
  type                   = "Microsoft.Resources/resourceGroups@2022-09-01"
  parent_id              = "/subscriptions/${local.account_id_stg}"
  response_export_values = ["*"]
}

# Find RGs - Prd
data "azapi_resource_list" "prd_rgs" {
  provider               = azapi.prd
  type                   = "Microsoft.Resources/resourceGroups@2022-09-01"
  parent_id              = "/subscriptions/${local.account_id_prd}"
  response_export_values = ["*"]
}

# Identify all RG names, filter by regex string
locals {
  dev_rg_names = [for rg in jsondecode(data.azapi_resource_list.dev_rgs.output).value[*].name : rg if can(regex("p\\d\\d\\d-net", rg))]
  stg_rg_names = [for rg in jsondecode(data.azapi_resource_list.stg_rgs.output).value[*].name : rg if can(regex("p\\d\\d\\d-net", rg))]
  prd_rg_names = [for rg in jsondecode(data.azapi_resource_list.prd_rgs.output).value[*].name : rg if can(regex("p\\d\\d\\d-net", rg))]
}

# Costruct subnet names - Dev
data "azapi_resource_list" "dev_subnets" {
  for_each               = toset(local.dev_rg_names)
  provider               = azapi.dev
  type                   = "Microsoft.Network/virtualNetworks/subnets@2022-09-01"
  parent_id              = "/subscriptions/${local.account_id_dev}/resourceGroups/${each.value}/providers/Microsoft.Network/virtualNetworks/vh-dev-vnet"
  response_export_values = ["*"]
}

# Costruct subnet names - Stg
data "azapi_resource_list" "stg_subnets" {
  for_each               = toset(local.stg_rg_names)
  provider               = azapi.stg
  type                   = "Microsoft.Network/virtualNetworks/subnets@2022-09-01"
  parent_id              = "/subscriptions/${local.account_id_stg}/resourceGroups/${each.value}/providers/Microsoft.Network/virtualNetworks/vh-stg-vnet"
  response_export_values = ["*"]
}

# Costruct subnet names - Prd
data "azapi_resource_list" "prd_subnets" {
  for_each               = toset(local.prd_rg_names)
  provider               = azapi.prd
  type                   = "Microsoft.Network/virtualNetworks/subnets@2022-09-01"
  parent_id              = "/subscriptions/${local.account_id_prd}/resourceGroups/${each.value}/providers/Microsoft.Network/virtualNetworks/vh-prd-vnet"
  response_export_values = ["*"]
}

# Preprocess
locals {
  dev_subnet_preprocess = { for rg_name, rg_values in data.azapi_resource_list.dev_subnets[*] : rg_name => rg_values }
  stg_subnet_preprocess = { for rg_name, rg_values in data.azapi_resource_list.stg_subnets[*] : rg_name => rg_values }
  prd_subnet_preprocess = { for rg_name, rg_values in data.azapi_resource_list.prd_subnets[*] : rg_name => rg_values }
  subnet_names = flatten(
    concat(
      [
        for rg in local.dev_subnet_preprocess["0"] : jsondecode(rg.output).value[*].name
      ],
      [
        for rg in local.stg_subnet_preprocess["0"] : jsondecode(rg.output).value[*].name
      ],
      [
        for rg in local.prd_subnet_preprocess["0"] : jsondecode(rg.output).value[*].name
      ]
    )
  )
  subnet_ids = flatten(
    concat(
      [
        for rg in local.dev_subnet_preprocess["0"] : jsondecode(rg.output).value[*].id
      ],
      [
        for rg in local.stg_subnet_preprocess["0"] : jsondecode(rg.output).value[*].id
      ],
      [
        for rg in local.prd_subnet_preprocess["0"] : jsondecode(rg.output).value[*].id
      ]
    )
  )
}
