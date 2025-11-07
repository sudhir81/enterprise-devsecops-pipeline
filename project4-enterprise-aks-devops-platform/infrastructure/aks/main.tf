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

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-${var.environment}"

  # Node pool settings
  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = var.aks_node_size
    type       = "VirtualMachineScaleSets"
  }

  # Enable system-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  # ✅ Enable Azure CNI network plugin
  network_profile {
    network_plugin     = "azure"
    load_balancer_sku  = "standard"
    outbound_type      = "loadBalancer"
  }

  # ✅ Enable Azure Policy Add-on for governance
  addon_profile {
    azure_policy {
      enabled = true
    }
  }

  # Optional — make AKS private & secure
  api_server_authorized_ip_ranges = []

  # Versioning
  kubernetes_version = var.kubernetes_version

  tags = {
    environment = var.environment
    managed_by  = "GitHubActions"
  }
}

