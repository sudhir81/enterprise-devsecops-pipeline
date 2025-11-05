package terraform.policy

deny[msg] {
  input.resource_changes[_].type == "azurerm_container_registry"
  registry := input.resource_changes[_].change.after
  registry.admin_enabled == true
  msg := "❌ ACR admin account must be disabled (admin_enabled = false)"
}

deny[msg] {
  input.resource_changes[_].type == "azurerm_container_registry"
  registry := input.resource_changes[_].change.after
  not registry.public_network_access == "Disabled"
  msg := "❌ ACR must have public network access disabled (public_network_access = 'Disabled')"
}
