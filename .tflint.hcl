plugin "azurerm" {
  enabled = true
}

config {
  call_module_type = "all"
}

#sjekker for ubrukte variabler
rule "terraform_unused_declarations" {
  enabled = true
}


