  variable "rg_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Deployment environment (dev, preprod, prod)"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner or team responsible for resources"
  type        = string
  default     = "sudhir"
}

variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "entdevops"
}

variable "acr_name" {
  description = "Azure Container Registry name"
  type        = string
}

variable "aks_cluster_name" {
  description = "Azure Kubernetes Service cluster name"
  type        = string
}

variable "aks_resource_group" {
  description = "Resource group for AKS"
  type        = string
}

variable "aks_node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 1
}

variable "aks_node_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B4ms"
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to use for the cluster"
  type        = string
  default     = "1.30.3"
}