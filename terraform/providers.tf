/* =========== SET UP ALL PROVIDERS =========== */

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    namecheap = {
      source  = "namecheap/namecheap"
      version = ">= 2.0.0"
    }
  }
}

/* ========== PROVIDER CONFIGURATION ========== */

provider "digitalocean" {
  token = var.DIGITAL_OCEAN_TOKEN
}

provider "namecheap" {
  user_name = var.NAMECHEAP_USER
  api_user  = var.NAMECHEAP_USER
  api_key   = var.NAMECHEAP_API_KEY
}

/* =============== LOAD SSH KEYS ============== */

# Load the public SSH key registered in Digital Ocean
data "digitalocean_ssh_key" "main" {
  name = var.DIGITAL_OCEAN_SSH_KEY_NAME
}
