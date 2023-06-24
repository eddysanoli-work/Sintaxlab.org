# Note: The values for these variables are found in "terraform.tfvars".

/* ============================================ */
/* LINODE API TOKEN                             */
/* ============================================ */

# API Token for access through Terraform
variable "LINODE_API_TOKEN" {
    type = string
    default = ""
}

/* ============================================ */
/* NANODE ROOT PASSWORD                         */
/* ============================================ */

# Password for the root user of the nanode 
variable "LINODE_ROOT_PASS" {
    type = string
}

/* ============================================ */
/* PUBLIC SSH KEY                               */
/* ============================================ */

# Public SSH keys that can access the nanode
variable "PUBLIC_SSH_KEY" {
    type = string
}