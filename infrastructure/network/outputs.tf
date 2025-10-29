output "resource_group_name" {
  description = "Azure Resource Group Name"
  value       = azurerm_resource_group.rg.name
}

output "vnet_name" {
  description = "Azure Virtual Network Name"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_name" {
  description = "Azure Subnet Name"
  value       = azurerm_subnet.subnet.name
}

