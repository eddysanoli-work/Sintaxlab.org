/* ============================================ */
/* EDDYSANOLI.COM LINODE                        */
/* ============================================ */

# 2 GB Linode
resource "linode_instance" "eddysanoli_server" {
    label = "eddysanoli-server"
    image = "linode/debian11"
    region = "us-southeast"

    # All linode terraform types:
    # https://api.linode.com/v4/linode/types
    type = "g6-standard-1" 

    # Root password for the nanode
    root_pass = var.LINODE_ROOT_PASS

    # Authorized SSH keys
    authorized_keys = [
        var.PUBLIC_SSH_KEY
    ]

    # Render the "hosts.tpl" template that will be used by Ansible 
    provisioner "local-exec" {

        # Fill content of the hosts file in "ansible/hosts" using the "hosts.tpl" template
        command = templatefile("hosts.tpl", {
            server_ip = self.ip_address
        })

        # Run it using bash
        interpreter = ["bash", "-c"]
    }
}

/* ============================================ */
/* DOMAIN                                       */
/* ============================================ */

# Eddysanoli.com domain 
resource "linode_domain" "eddysanoli_domain" {

    # Namecheap domain
    domain = "eddysanoli.com"

    # Either "master" or "slave". Master domains are authoritative for their
    # domain, and slave domains are not.
    type = "master"

    # Address that reaches you but its outside your domain and ideally
    # doesn't require your linode to be operational. Gmail for example
    soa_email = "eddysanoli@gmail.com"

    # TTL (Time to Live) for the domain cache
    # Note: This is not respected by all DNS servers. Its more of a suggestion
    ttl_sec = 3600
}

/* ============================================ */
/* DOMAIN RECORDS                               */
/* ============================================ */

# "Eddysanoli" Main Domain Record (No Prefix)
# (eg. eddysanoli.com)
resource "linode_domain_record" "eddysanoli_domain_record" {
    domain_id = linode_domain.eddysanoli_domain.id
    name = "eddysanoli.com"
    record_type = "A"
    target = linode_instance.eddysanoli_server.ip_address

    # How often the record refreshes its cache
    # Note: This may not be respected by all DNS servers. Its more of a suggestion
    ttl_sec = 3600
}

# "EddysanolI" www Domain Record
# (eg. www.eddysanoli.com)
resource "linode_domain_record" "eddysanoli_domain_record_www" {
    domain_id = linode_domain.eddysanoli_domain.id
    name = "www.eddysanoli.com"
    record_type = "CNAME"

    # This wont target to the IP address of the linode instance
    # but the "A" record of the domain name so that both lead to the same page
    target = "eddysanoli.com" 

    # TTL (Time to live). Frequency for record cache refresh in seconds
    # Note: This may not be respected by all DNS servers. Its more of a suggestion
    ttl_sec = 3600
}

# "EddysanolI" bot Domain Record / For the discord bot
# (eg. bot.eddysanoli.com)
resource "linode_domain_record" "eddysanoli_domain_record_bot" {
    domain_id = linode_domain.eddysanoli_domain.id
    name = "bot.eddysanoli.com"
    record_type = "CNAME"

    # This wont target to the IP address of the linode instance
    # but the "A" record of the domain name so that both lead to the same page
    target = "eddysanoli.com" 

    # TTL (Time to live). Frequency for record cache refresh in seconds
    # Note: This may not be respected by all DNS servers. Its more of a suggestion
    ttl_sec = 3600
}