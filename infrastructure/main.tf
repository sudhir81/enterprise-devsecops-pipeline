# Root: create resource group then call modules
variable "location" {}
variable "prefix" {}
variable "environment" {}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}-rg"
  location = var.location
  tags = {
    project     = "enterprise-aks-devops"
    environment = var.environment
  }
}

module "acr" {
  source = "./infrastructure/acr"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  acr_name = var.acr_name
}

module "monitoring" {
  source = "./infrastructure/monitoring"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  prefix = "${var.prefix}-${var.environment}"
}

module "aks" {
  source = "./infrastructure/aks"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  prefix = "${var.prefix}-${var.environment}"
  aks_node_count = var.aks_node_count
  aks_node_size  = var.aks_node_size
  kubernetes_version = var.kubernetes_version
  acr_id = module.acr.acr_id
  log_analytics_workspace_id = module.monitoring.law_workspace_id
}

