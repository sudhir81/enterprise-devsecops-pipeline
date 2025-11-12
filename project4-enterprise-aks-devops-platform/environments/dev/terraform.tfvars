# ---------------------------------------
# 🌍 Dev Environment Configuration
# ---------------------------------------

rg_name          = "rg-devsecops-dev"
location         = "eastus"
environment      = "dev"
owner            = "sudhir"
prefix           = "entdevops"

# ☸️ AKS Configuration
aks_cluster_name   = "devops-aks"
aks_resource_group = "rg-devsecops-dev"
aks_node_size      = "Standard_B4ms"
aks_node_count     = 1
kubernetes_version = "1.29.7"

# 🏗️ ACR
acr_name    = "devopsacr001"
image_name  = "sampleapp"

# 🔐 Azure Auth (auto-injected from GitHub secrets, not used here)
# subscription_id = ""
# client_id       = ""
# client_secret   = ""
# tenant_id       = ""