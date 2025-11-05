package terraform.policy

deny[msg] if {
  some r
  r := input.resource_changes[_]
  r.type == "azurerm_container_registry"
  r.change.after.admin_enabled == true
  msg := "❌ ACR admin account must be disabled (admin_enabled = false)"
}

deny[msg] if {
  some r
  r := input.resource_changes[_]
  r.type == "azurerm_container_registry"
  not r.change.after.public_network_access == "Disabled"
  msg := "❌ ACR must have public network access disabled (public_network_access = 'Disabled')"
}
