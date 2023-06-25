/* ============================================ */
/* DROPLET                                      */
/* ============================================ */

resource "digitalocean_droplet" "demo-app" {
  image  = "ubuntu-20-04-x64"
  name   = "demo-app"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.main.id
  ]

  # Setup an SSH connection to the droplet
  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.PRIVATE_SSH_KEY_PATH)
    timeout     = "2m"
  }

  # Render the "hosts.tpl" template that will be used by Ansible 
  provisioner "local-exec" {

    # Fill content of the hosts file in "ansible/hosts" using the "hosts.tpl" template
    command = templatefile("hosts.tpl", {
      server_ip = self.ipv4_address
    })

    # Run it using bash
    interpreter = ["bash", "-c"]
  }
}

/* ============================================ */
/* DOMAIN                                       */
/* ============================================ */

resource "digitalocean_domain" "sintaxlab" {
  name       = var.DOMAIN_NAME
  ip_address = digitalocean_droplet.demo-app.ipv4_address
}

# A Record: Associates a domain name with an IP address
resource "digitalocean_record" "A-record" {
  domain = digitalocean_domain.sintaxlab.name
  type   = "A"
  name   = "www"
  value  = digitalocean_droplet.demo-app.ipv4_address
}

# CNAME Record: Associates a subdomain with a domain name
resource "digitalocean_record" "DEMO-CNAME-record" {
  domain = digitalocean_domain.sintaxlab.name
  type   = "CNAME"
  name   = "demo"
  value  = "@"
}

/* ============================================ */
/* NAMECHEAP NAMESERVERS                        */
/* ============================================ */

# Add the nameservers of the hosted zone to the domain
# (Make sure that your IP address is whitelisted in the API settings of Namecheap)
resource "namecheap_domain_records" "sintaxlab-org" {
  domain = var.DOMAIN_NAME

  # Remove the previous nameservers and add the new ones
  mode = "OVERWRITE"

  # The nameservers from the "noobsquad.xyz" main hosted zone
  nameservers = [
    "ns1.digitalocean.com",
    "ns2.digitalocean.com",
    "ns3.digitalocean.com"
  ]
}
