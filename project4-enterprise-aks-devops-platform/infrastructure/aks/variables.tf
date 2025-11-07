# ============================================================
# General Configuration
# ============================================================

variable "location" {
  description = "Azure region for resource deployment."
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name (e.g., dev, preprod, prod)."
  type        = string
  default     = "dev"
}

variable "rg_name" {
  description = "Name of the resource group."
  type        = string
  default     = "rg-devsecops-dev"
}

variable "owner" {
  description = "Owner tag for resource identification."
  type        = string
  default     = "sudhir"
}

variable "prefix" {
  description = "Prefix used for naming AKS and ACR resources."
  type        = string
  default     = "entdevops"
}

# ============================================================
# Azure Container Registry (ACR)
# ============================================================

variable "acr_name" {
  description = "Azure Container Registry name."
  type        = string
  default     = "devopsacr001"
}

variable "acr_sku" {
  description = "ACR SKU: Basic, Standard, or Premium."
  type        = string
  default     = "Standard"
}

# ============================================================
# AKS Configuration
# ============================================================

variable "aks_node_count" {
  description = "Number of nodes in the default AKS node pool."
  type        = number
  default     = 2
}

variable "aks_node_size" {
  description = "VM size for the AKS node pool."
  type        = string
  default     = "Standard_B4ms"
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version."
  type        = string
  default     = "1.29.2"
}

variable "private_cluster_enabled" {
  description = "Enable private AKS cluster."
  type        = bool
  default     = false
}

variable "disk_encryption_set_id" {
  description = "Disk Encryption Set ID for AKS node disks (optional)."
  type        = string
  default     = ""
}

variable "log_analytics_workspace_id" {
  description = "Azure Log Analytics workspace ID for AKS monitoring."
  type        = string
  default     = ""
}

# ============================================================
# Tags
# ============================================================

variable "common_tags" {
  description = "Common tags applied to all Azure resources."
  type        = map(string)
  default = {
    project     = "Enterprise-AKS-DevSecOps"
    managed_by  = "GitHubActions"
  }
}

