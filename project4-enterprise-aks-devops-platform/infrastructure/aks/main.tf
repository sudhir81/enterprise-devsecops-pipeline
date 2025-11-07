############################################################
# main.tf - AKS (improved for Checkov / Azure best-practices)
# Drop into: project4-enterprise-aks-devops-platform/infrastructure/aks/
# Assumes variables are declared in variables.tf (same var names used).
############################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# -------------------------
# Resource Group (if not defined elsewhere)
# -------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags = {
    environment = var.environment
    owner       = var.owner != "" ? var.owner : "devops"
  }
}

# -------------------------
# Log Analytics Workspace (for AKS monitoring)
# -------------------------
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_days
  tags = {
    environment = var.environment
  }
}

# -------------------------
# Optional Disk Encryption Set ID (provide via var if you have one)
# -------------------------
# If you manage a disk encryption set and want AKS to use it set var.disk_encryption_set_id
# Otherwise leave blank.
locals {
  disk_encryption_set_id = length(trim(var.disk_encryption_set_id)) > 0 ? var.disk_encryption_set_id : null
}

# -------------------------
# Container Registry (ACR) - hardened defaults
# -------------------------
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku # e.g., Standard or Premium (required for geo-replication, scanning features)
  admin_enabled       = false      # admin account disabled for security

  # optional: network_rule_set and public_network_enabled can be used to block public network
  # if you want, set var.acr_public_network_enabled = false to restrict access via private endpoints
  georeplication_locations = var.acr_georeplication_locations

  tags = {
    environment = var.environment
  }
}

# -------------------------
# AKS Cluster (compliant configuration)
# -------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-${var.environment}-${var.prefix}"

  # Node pool (VMSS) - required by many policies
  default_node_pool {
    name                       = "default"
    node_count                 = var.aks_node_count
    vm_size                    = var.aks_node_size
    type                       = "VirtualMachineScaleSets"
    max_pods                   = var.max_pods
    os_disk_size_gb            = var.node_os_disk_size_gb
    enable_node_public_ip      = false
    vnet_subnet_id             = length(trim(var.node_subnet_id)) > 0 ? var.node_subnet_id : null
    tags = {
      role = "system"
    }
  }

  # Managed Identity
  identity {
    type = "SystemAssigned"
  }

  # Networking - Azure CNI (required by Checkov)
  network_profile {
    network_plugin    = "azure"          # <--- Azure CNI (AKSPod IPs on vnet)
    load_balancer_sku = "standard"
    outbound_type     = var.outbound_type # e.g., "loadBalancer" or "userDefinedRouting"
  }

  # Addons
  addon_profile {
    azure_policy {
      enabled = true   # <--- satisfy CKV_AZURE_116 (Azure Policy add-on)
    }
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
    }
    # optionally enable other addons (http_application_routing false by default)
  }

  # API Server - consider private cluster in sensitive envs
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges # [] for none, or provide list
  private_cluster_enabled         = var.private_cluster_enabled

  # Enable RBAC for CKV_AZURE_5
  role_based_access_control {
    enabled = true
  }

  kubernetes_version = var.kubernetes_version

  # Ensure control plane is on paid SKU if needed (this is Azure-managed; audit tools expect certain settings)
  sku_tier = var.sku_tier # "Free" or "Paid" - set to "Paid" for production SLA

  # Disk encryption set for nodes (optional)
  disk_encryption_set_id = local.disk_encryption_set_id

  # Tags
  tags = merge(
    {
      environment = var.environment
      managed_by  = "github-actions"
    },
    var.common_tags
  )

  # Optionally enable API server authorized IPs (set via var)
  # kubernetes_cluster_autoscaler_profile or upgrade channel can be added here if you want auto-upgrades
  automatic_channel_upgrade       = var.automatic_channel_upgrade
  automatic_upgrade_channel       = var.automatic_upgrade_channel
}

# -------------------------
# Role assignment to allow ACR pull (if ACR in same subscription)
# This grants pull permission to cluster's identity (if you want automated image pulls)
# -------------------------
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  depends_on           = [azurerm_kubernetes_cluster.aks]
}

# -------------------------
# Outputs (useful for pipeline)
# -------------------------
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_kube_config" {
  description = "Kubeconfig (base64). Use with `terraform output -raw aks_kube_config | base64 --decode > kubeconfig`"
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive   = true
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

