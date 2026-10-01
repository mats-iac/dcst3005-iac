# Lim inn verdiene fra 'terraform output backend_hcl_template' etter bootstrap.


resource_group_name  = "rg-tfstate-matsotdemo"
storage_account_name = "sttflwqz59"
container_name       = "tfstate"
use_azuread_auth     = true
use_cli              = true