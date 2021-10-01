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

  # scratch_disk {
  #   interface = "SCSI"
  # }

  network_interface {
    network = "default"

    access_config {
      // Ephemral public IP
    }
  }

  service_account {
    email = google_service_account.account.email
    scopes = [ "cloud-platform" ]
  }
}