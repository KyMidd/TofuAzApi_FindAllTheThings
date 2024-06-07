data "azurerm_subscription" "current" {}

locals {
  # Define RG where VMs live
  rg_name = "rg-name"
}

# Find all RGs in the subscription and filter
# This is used to prevent a failure when the RG doesn't exist yet
data "azapi_resource_list" "subscription_rgs" {
  type                   = "Microsoft.Resources/resourceGroups@2022-09-01"
  parent_id              = "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
  response_export_values = ["*"]
}

# Filter list for VM RG name
locals {
  rg = [for rg in jsondecode(data.azapi_resource_list.subscription_rgs.output).value[*].name : rg if can(regex(local.rg_name, rg))]
}

# Find all VMs in GW Subnet using AZAPI
data "azapi_resource_list" "server" {
  count                  = length(local.rg) == 0 ? 0 : 1
  type                   = "Microsoft.Compute/virtualMachines@2024-03-01"
  parent_id              = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${local.rg_name}"
  response_export_values = ["*"]
}

# Filter for the GW hosts
locals {
  server_names = length(local.rg) == 0 ? [] : [for vm in jsondecode(data.azapi_resource_list.server[0].output).value[*].name : vm if can(regex("ras", vm))]
}

# Look up the GW host info. If there are none, no hosts will be added to backend pool
data "azurerm_virtual_machine" "gw_host" {
  # Iterate over gateway server names. If none, this resource isn't built
  for_each            = length(local.server_names) == 0 ? toset([]) : toset(local.server_names)
  name                = each.value
  resource_group_name = local.rg_name
}

locals {
  gw_private_ips = length(local.server_names) == 0 ? [] : [for vm in data.azurerm_virtual_machine.gw_host : vm.private_ip_address]
}
