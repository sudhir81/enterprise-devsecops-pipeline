location           = "eastus"
environment        = "dev"
prefix             = "tf-aks-dev"
acr_name           = "tfacrdev12345"   # must be globally unique
aks_node_count     = 1
aks_node_size      = "Standard_DS2_v2"
kubernetes_version = "1.28.10"

