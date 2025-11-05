package terraform.policy

deny[msg] if {
  count([r | r := input.resource_changes[_]; r.type == "azurerm_monitor_diagnostic_setting"]) == 0
  msg := "❌ Monitoring: Diagnostic settings must be enabled for AKS or critical resources"
}
