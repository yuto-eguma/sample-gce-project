provider "google" {
  project = var.project_id
  region  = var.region
}

module "naming" {
  source = "../../_module/naming"
  role   = local.role
}

resource "google_compute_network" "vpc_network" {
  name                    = module.naming.name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "${module.naming.name}-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_firewall" "default" {
  name    = module.naming.name
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  source_tags = [module.naming.name]
}