terraform {
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "naming" {
  source = "../_module/naming"
  role   = local.role
}

resource "google_service_account" "account" {
  account_id   = module.naming.name
  display_name = "Account Name"
}