plugin "azurerm" {
  enabled = true
}

config {
  call_module_type = "all"
}

rule "terraform_unused_declarations" {
  enabled = true
}


