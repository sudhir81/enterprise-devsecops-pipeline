##########################################
# 🌍 Environment Configuration Variables
##########################################

variable "rg_name" {
  description = "Name of the Azure Resource Group for AKS and related resources."
  type        = string
  default     = "rg-devsecops-dev"
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, preprod, prod)."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner or responsible person/team for tagging purposes."
  type        = string
  default     = "sudhir"
}

variable "prefix" {
  description = "Prefix to use for naming Azure resources."
  type        = string
  default     = "entdevops"
}


##########################################
# ☸️ AKS Cluster Configuration Variables
##########################################

variable "aks_cluster_name" {
  description = "Name of the Azure Kubernetes Service (AKS) cluster."
  type        = string
  default     = "devops-aks"
}

variable "aks_resource_group" {
  description = "Resource group that will contain the AKS cluster."
  type        = string
  default     = "rg-devsecops-dev"
}

variable "aks_node_size" {
  description = "The size of the virtual machines used for the AKS node pool."
  type        = string
  default     = "Standard_B4ms"
}

variable "aks_node_count" {
  description = "Initial number of nodes in the AKS default node pool."
  type        = number
  default     = 1
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster."
  type        = string
  default     = "1.29.7"
}


##########################################
# 🏗️ ACR (Azure Container Registry)
##########################################

variable "acr_name" {
  description = "Name of the Azure Container Registry."
  type        = string
  default     = "devopsacr001"
}

variable "image_name" {
  description = "Docker image name to be deployed from ACR."
  type        = string
  default     = "sampleapp"
}


##########################################
# 🔐 Azure Authentication Variables
##########################################

variable "subscription_id" {
  description = "Azure Subscription ID used by Terraform and the AzureRM provider."
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Azure Service Principal Client ID."
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure Service Principal Client Secret."
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID."
  type        = string
  sensitive   = true
}
