# Specify the Terraform provider and version
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5"
    }
  }

  required_version = ">= 0.12"
}

# Configure the Google Cloud provider
provider "google" {
  credentials = file("gcp-sa.json")
  project = "epam-cicd-iac-demo"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-a"
}

# Create a new VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "epam-cicd-iac-demo-vpc-network"
  auto_create_subnetworks = false
}

# Create a subnet within the VPC
resource "google_compute_subnetwork" "subnet" {
  name          = "epam-cicd-iac-demo-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-southeast1"
  network       = google_compute_network.vpc_network.self_link
}

# Create a compute engine instance for hosting demo application
resource "google_compute_instance" "vm_instance" {
  name         = "epam-demo-instance"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }

  metadata = {
    startup-script = <<-EOT
      sudo apt-get update
      # Install packages to allow apt to use a repository over HTTPS
      sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
      # Add Docker’s official GPG key
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      # Set up the stable repository
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      # Update the apt package index again
      sudo apt-get update
      # Install the latest version of Docker CE
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io
      # Install Docker Compose
      sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose
    EOT
  }

  tags = ["epam-demo", "allow-iap-ssh"]
}

# Add firewall rule to allow gcloud IAP tunnel SSH
resource "google_compute_firewall" "iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["allow-iap-ssh"]

  # Source ranges for IAP's TCP forwarding
  source_ranges = ["35.235.240.0/20"]

  priority = 1000

  description = "Allow SSH access from IAP's TCP forwarding"
}
