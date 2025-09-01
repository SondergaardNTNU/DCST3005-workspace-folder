#locals.tf
locals {



  common_tags = {
    owner       = var.owner
    environment = "test"
    project     = "demosql"
    costcenter  = "DCST3005-SHS"
  }

  resource_group_name = "${var.nameprefix}-rg-${var.project}-${var.suffix}"
  sql_server_name     = "${var.nameprefix}-sql-${var.project}-${var.suffix}"
  sql_database_name   = "${var.nameprefix}-sqldb-${var.project}-${var.suffix}"
  location            = var.location




}