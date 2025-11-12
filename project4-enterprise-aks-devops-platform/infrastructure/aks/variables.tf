# ----------------------------
#  Azure AKS Infrastructure Variables
# ----------------------------

variable "rg_name" {
  description = "Name of the Resource Group"
  type        = string
  default     = "rg-devsecops-dev"
}

variable "location" {
  description = "Azure location for resources"
  type        = string
  default     = "East US"
}

variable "owner" {
  description = "Owner tag"
  type        = string
  default     = "sudhir"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
  default     = "entdevops"
}

variable "aks_cluster_name" {
  description = "AKS cluster name"
  type        = string
  default     = "devops-aks"
}

variable "aks_node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "aks_node_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B4ms"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29.0"
}

variable "disk_encryption_set_id" {
  description = "Optional disk encryption set ID"
  type        = string
  default     = ""
}
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "client_id" {
  description = "Azure Service Principal Client ID"
  type        = string
}

variable "client_secret" {
  description = "Azure Service Principal Client Secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}
