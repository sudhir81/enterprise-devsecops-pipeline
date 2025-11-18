##########################################
# 🔧 Terraform & Provider Configuration
##########################################

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Using Azure CLI or OIDC for authentication (no client_secret here)
provider "azurerm" {
  features {}
}

##########################################
# 🌍 Resource Group
##########################################

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location

  tags = {
    environment = var.environment
    owner       = var.owner
  }
}

##########################################
# ☸️ AKS Cluster
##########################################

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}-aks"

  default_node_pool {
    name                 = "default"
    vm_size              = var.aks_node_size
    node_count           = var.aks_node_count
    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 3
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr   = "10.0.0.0/16"
    dns_service_ip = "10.0.0.10"
    outbound_type  = "loadBalancer"
  }

  kubernetes_version = var.kubernetes_version

  tags = {
    environment = var.environment
    owner       = var.owner
  }
}

##########################################
# 📦 Outputs
##########################################

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_kube_config" {
  description = "Kubeconfig for the AKS cluster (raw)"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}
