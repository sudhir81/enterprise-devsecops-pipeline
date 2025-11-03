resource_group_name = "rg-devsecops-prod"
location            = "eastus"
vnet_name           = "vnet-devsecops-prod"
subnet_name         = "subnet-prod"
vnet_address_space  = ["10.20.0.0/16"]
subnet_prefixes     = ["10.20.1.0/24"]

tags = {
  environment = "prod"
  owner       = "Sudhir"
}
