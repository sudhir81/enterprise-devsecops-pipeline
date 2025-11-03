resource_group_name = "rg-devsecops-preprod"
location            = "eastus"
vnet_name           = "vnet-devsecops-preprod"
subnet_name         = "subnet-preprod"
vnet_address_space  = ["10.10.0.0/16"]
subnet_prefixes     = ["10.10.1.0/24"]

tags = {
  environment = "preprod"
  owner       = "Sudhir"
}
