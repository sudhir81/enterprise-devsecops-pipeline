variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "East US"
}

variable "rg_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-devsecops-dev"
}

variable "owner" {
  description = "Owner tag for resources"
  type        = string
  default     = "devops"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "acr_name" {
  description = "Azure Container Registry name"
  type        = string
  default     = "devopsacr001"
}

variable "aks_cluster_name" {
  description = "AKS cluster name"
  type        = string
  default     = "devops-aks"
}

variable "aks_node_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B4ms"
}

variable "aks_node_count" {
  description = "Number of nodes in default pool"
  type        = number
  default     = 2
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version"
  type        = string
  default     = "1.29.0"
}

variable "disk_encryption_set_id" {
  description = "Optional disk encryption set ID"
  type        = string
  default     = ""
}