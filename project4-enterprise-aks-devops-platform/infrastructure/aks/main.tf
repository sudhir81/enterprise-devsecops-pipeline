terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}
}

# ============================================================
# Resource Group
# ============================================================
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location

  tags = merge(var.common_tags, {
    environment = var.environment
    owner       = var.owner != "" ? var.owner : "devops"
  })
}

# ============================================================
# Azure Container Registry (ACR)
# ============================================================
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = false
  public_network_access_enabled = false

  tags = var.common_tags
}

# ============================================================
# Azure Kubernetes Cluster (AKS)
# ============================================================

locals {
  disk_encryption_set_id = length(trim(var.disk_encryption_set_id, " ")) > 0 ? var.disk_encryption_set_id : null
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-${var.environment}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}-${var.environment}"

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name                = "default"
    node_count          = var.aks_node_count
    vm_size             = var.aks_node_size
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    enable_node_public_ip = false
    os_disk_type        = "Ephemeral"
  }

  identity {
    type = "SystemAssigned"
  }

  # Optional Disk Encryption
  dynamic "disk_encryption_set_id" {
    for_each = local.disk_encryption_set_id != null ? [1] : []
    content {
      id = local.disk_encryption_set_id
    }
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    dns_service_ip    = "10.0.0.10"
    service_cidr      = "10.0.0.0/16"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  private_cluster_enabled = var.private_cluster_enabled

  # Add-on profiles
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = merge(var.common_tags, {
    environment = var.environment
  })
}

# ============================================================
# Outputs
# ============================================================

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "acr_login_server" {
  description = "The login server of the ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "aks_kube_config" {
  description = "Kubeconfig (base64 encoded)"
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive   = true
}

