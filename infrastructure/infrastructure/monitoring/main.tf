variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "prefix" { type = string }

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = var.prefix
  }
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}
