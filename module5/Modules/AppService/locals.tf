locals {
  rg_name = "rg-${var.environment}-${var.name_prefix}"
  tags = merge({
    environment = var.environment
    module      = "AppService"
    owner       = "Sondre H. Søndergaard"
    billing     = "DCST3005"
    purporse    = "Web Application Hosting"
  }, var.tags)
}