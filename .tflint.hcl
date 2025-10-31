plugin "azurerm" {
  enabled = true
}

config {
  call_module_type = "all"
}

rule "terraform_unused_declarations" {
  enabled = true
}

# Eksempel: skru av en regel (hvis dere har bevisst avvik)
# rule "azurerm_storage_account_invalid_name" {
#   enabled = false
# }

rule "terraform_unused_declarations" {
  enabled = false
}