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

# -----------------------------------------------
# RESOURCE GROUP
# -----------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location

  tags = {
    environment = var.environment
    owner       = var.owner
  }
}

# -----------------------------------------------
# AZURE CONTAINER REGISTRY
# -----------------------------------------------
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
  tags = {
    environment = var.environment
  }
}

# -----------------------------------------------
# AZURE KUBERNETES SERVICE (AKS)
# -----------------------------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-${var.environment}"

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name                = "default"
    vm_size             = var.aks_node_size
    node_count          = var.aks_node_count
    auto_scaling_enabled = true       # ✅ correct placement
    min_count           = 1
    max_count           = 3
    enable_node_public_ip = false     # ✅ correct placement
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    load_balancer_sku  = "standard"
    outbound_type      = "loadBalancer"
    docker_bridge_cidr = "172.17.0.1/16"  # ✅ must be here
    service_cidr       = "10.0.0.0/16"
    dns_service_ip     = "10.0.0.10"
  }

  # Optional encryption set
  disk_encryption_set_id = var.disk_encryption_set_id != "" ? var.disk_encryption_set_id : null

  tags = {
    environment = var.environment
    owner       = var.owner
  }
}

# -----------------------------------------------
# OUTPUTS
# -----------------------------------------------
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}