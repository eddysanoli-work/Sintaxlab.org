# Note: The values for these variables are found in "terraform.tfvars".
# You shouldn't put those values in this file. This is just for connecting
# the .tfvars file to the .tf files.

/* ============================================ */
/* DIGITAL OCEAN                                */
/* ============================================ */

# API Token for access through Terraform
variable "DIGITAL_OCEAN_TOKEN" {
  type    = string
  default = ""
}

# Name for the registered public key in Digital Ocean
variable "DIGITAL_OCEAN_SSH_KEY_NAME" {
  type    = string
  default = ""
}

/* ============================================ */
/* SSH                                          */
/* ============================================ */

# Path to your personal "id_rsa" file
variable "PRIVATE_SSH_KEY_PATH" {
  type    = string
  default = ""
}

/* ============================================ */
/* DOMAIN                                       */
/* ============================================ */

variable "DOMAIN_NAME" {
  type    = string
  default = ""
}

/* ============================================ */
/* NAMECHEAP                                    */
/* ============================================ */

# Namecheap user and API key
# Only available if you have spent more than 50$ or if you have a balance of 50$ or more
variable "NAMECHEAP_USER" {
  type    = string
  default = ""
}
variable "NAMECHEAP_API_KEY" {
  type    = string
  default = ""
}
