variable "rg_name" {
  type        = string
  description = "Existing Resource Group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "owner" {
  type        = string
}

variable "prefix" {
  type        = string
}

variable "aks_cluster_name" {
  type        = string
}

variable "aks_node_size" {
  type        = string
}

variable "aks_node_count" {
  type        = number
}

variable "kubernetes_version" {
  type        = string
}
