package terraform.policy

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "azurerm_network_interface"
  resource.change.after.associate_public_ip_address == true
  msg := sprintf("Public IP not allowed on resource: %s", [resource.name])
}
