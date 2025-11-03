resource_group_name = "rg-devsecops-dev"
location            = "eastus"
vnet_name           = "vnet-devsecops-dev"
subnet_name         = "subnet-dev"
vnet_address_space  = ["10.0.0.0/16"]
subnet_prefixes     = ["10.0.1.0/24"]

tags = {
  environment = "dev"
  owner       = "Sudhir"
}
