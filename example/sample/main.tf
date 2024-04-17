module "vpc" {
  source = "../../"
  name   = "terraform-vpc"
  subnets = {
    "subnet-1" = {
      ip_cidr_range = "10.0.0.0/16"
      region        = "us-central1"
    },
    "subnet-2" = {
      ip_cidr_range = "10.1.0.0/16"
      region        = "us-central1"
    }
  }

  firewall_rules = {
    "allow-ssh" = {
      direction   = "INGRESS"
      description = "Allow SSH from anywhere"
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      source_ranges      = ["0.0.0.0/0"]
      destination_ranges = ["10.0.0.0/16"]
    }
  }
}
