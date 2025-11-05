package terraform.policy

deny[msg] if {
  some r
  r := input.resource_changes[_]
  r.type == "azurerm_kubernetes_cluster"
  not r.change.after.role_based_access_control_enabled
  msg := "❌ AKS must have RBAC enabled (role_based_access_control_enabled = true)"
}

deny[msg] if {
  some r
  r := input.resource_changes[_]
  r.type == "azurerm_kubernetes_cluster"
  not r.change.after.private_cluster_enabled
  msg := "❌ AKS must be deployed as a private cluster (private_cluster_enabled = true)"
}
