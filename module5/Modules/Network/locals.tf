locals {
  rg_name = "rg-${var.environment}-${var.name_prefix}"
  tags = merge({
    environment = var.environment
    module      = "Network"
    owner       = "Sondre H. Søndergaard"
    billing     = "DCST3005"
    purporse    = "Networking Infrastructure"
  }, var.tags)
}
