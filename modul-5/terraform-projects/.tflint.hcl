# Terraform-regler
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# Azure-regler
plugin "azurerm" {
  enabled = true
  version = "0.32.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# Krev snake_case i navn
rule "terraform_naming_convention" {
  enabled = true
}

# Krev beskrivelse på variabler
rule "terraform_documented_variables" {
  enabled = true
}

# Krev beskrivelse på outputs
rule "terraform_documented_outputs" {
  enabled = true
}