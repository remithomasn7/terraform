terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = var.project
  zone    = var.zone
}

provider "google" {
  alias   = "europe-west1"
  project = var.project
  region  = var.region_2
  zone    = var.zone_2
}


resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-medium"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    # The presence of the access_config block, even without any arguments, gives the VM an external IP address, making it accessible over the internet
    # All traffic to instances, even from other instances, is blocked by the firewall unless firewall rules are created to allow it.
    # Add a google_compute_firewall resource to allow traffic to access your instance.
    access_config {
    }
  }
}
