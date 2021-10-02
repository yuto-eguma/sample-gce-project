terraform {
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = "asia-northeast1-a"
}

module "naming" {
  source = "../_module/naming"
  role   = local.role
}

resource "google_service_account" "account" {
  account_id   = module.naming.name
  display_name = module.naming.name
}

resource "google_compute_instance" "default" {
  name         = module.naming.name
  machine_type = "e2-medium"
  zone         = "asia-northeast1-a"

  tags = [module.naming.name]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  service_account {
    email  = google_service_account.account.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = "sudo apt update && sudo apt -y install apache2 && echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' | sudo tee /var/www/html/index.html"
}

resource "google_compute_firewall" "default" {
  name    = module.naming.name
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  source_tags = google_compute_instance.default.tags
}