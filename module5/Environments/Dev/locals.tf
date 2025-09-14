locals {
  rg_name     = "rg-${var.environment}-${var.name_prefix}"
  environment = var.environment
  location    = var.location
  name_prefix = var.name_prefix
  tags = merge({
    environment = var.environment
    owner       = "Sondre H. Søndergaard"
    department  = "Development"
    purpose     = "Development Environment"
    cost_center = "DCST3005"
  }, var.tags)
}