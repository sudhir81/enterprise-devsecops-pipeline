variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "prefix" { type = string }
variable "aks_node_count" { type = number; default = 2 }
variable "aks_node_size" { type = string; default = "Standard_DS2_v2" }
variable "kubernetes_version" { type = string; default = "" }
variable "acr_id" { type = string }              # ID of ACR to attach

# Create AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.prefix}-dns"

  default_node_pool {
    name       = "agentpool"
    node_count = var.aks_node_count
    vm_size    = var.aks_node_size
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = var.kubernetes_version != "" ? var.kubernetes_version : null

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = var.prefix
  }

  depends_on = []
}

# Grant AKS's managed identity access to ACR (if ACR exists)
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.identity.0.principal_id

  depends_on = [azurerm_kubernetes_cluster.aks]
}
