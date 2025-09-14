locals {
  rg_name     = "rg-${var.environment}-${var.name_prefix}"
  tags = merge({
    environment = var.environment
    owner       = "Sondre H. Søndergaard"
    department  = "Testing"
    purpose     = "Testing Environment"
    cost_center = "DCST3005"
  }, var.tags)
}