variable "subnets" {
  default = {
    "subnet-1" = {
      ip_cidr_range = "10.0.0.0/16"
      region        = "us-central1"
    },
    "subnet-2" = {
      ip_cidr_range = "10.1.0.0/16"
      region        = "us-central1"
    }
  }
}

variable "firewall_rules" {
  default = {
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

