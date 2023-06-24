# Configure the provider: Linode
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Provider configuration
provider "linode" {

  # Use the declared variable from "variables.tf"
  token = var.LINODE_API_TOKEN
}
