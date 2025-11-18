variable "rg_name" {
  type = string
  description = "Resource Group name"
}

variable "location" {
  type = string
  description = "Azure region (e.g. eastus)"
}

variable "environment" {
  type = string
  description = "Environment tag (dev/preprod/prod)"
}

variable "owner" {
  type = string
  description = "Owner tag"
}

variable "prefix" {
  type = string
  description = "Prefix for resources and DNS"
}

variable "aks_cluster_name" {
  type = string
  description = "AKS cluster name"
}

variable "aks_node_size" {
  type = string
  description = "AKS node VM size"
  default = "Standard_B4ms"
}

variable "aks_node_count" {
  type = number
  description = "Initial node count for the default node pool"
  default = 1
}

variable "kubernetes_version" {
  type = string
  description = "Kubernetes version to use (region-dependent)"
  default = "1.28.5"
}
