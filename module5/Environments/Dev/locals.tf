locals {
  rg_name     = "rg-${var.environment}-${var.name_prefix}"
  environment = var.environment
  location    = var.location
  name_prefix = var.name_prefix
  tags = merge({
    environment = var.environment
    owner       = "Sondre H. Søndergaard"
    department  = "Development"
  }, var.tags)
}