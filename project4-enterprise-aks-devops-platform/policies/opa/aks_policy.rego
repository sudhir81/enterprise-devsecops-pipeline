package terraform.policy

deny[msg] {
  input.resource_changes[_].type == "azurerm_kubernetes_cluster"
  cluster := input.resource_changes[_].change.after
  not cluster.role_based_access_control_enabled
  msg := "❌ AKS must have RBAC enabled (role_based_access_control_enabled = true)"
}

deny[msg] {
  input.resource_changes[_].type == "azurerm_kubernetes_cluster"
  cluster := input.resource_changes[_].change.after
  not cluster.private_cluster_enabled
  msg := "❌ AKS must be deployed as a private cluster (private_cluster_enabled = true)"
}
