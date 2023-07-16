# Sintaxlab Website

## Setup

### Infrastructure (Terraform)

1. `cd terraform`
2. `terraform init` to initialize the terraform project
3. `terraform plan` to see the changes that will be applied to the infrastructure
4. `terraform apply` to apply the changes to the infrastructure. This will create the Ubuntu server (droplet) on DigitalOcean, configure the domain on NameCheap and create some DNS records on DigitalOcean to link the droplet with the domain. It also populates the `ansible/hosts` file with the IP of the droplet.

### Provisioning (Ansible)

1. `cd ansible`
2. `docker compose up` to start provisioning. This will update the packages on the droplet, install Pyenv, install Python 3.9, clones the HormoziGPT repository and then it installs the dependencies for the project.

### Start the Application

1. Remote into the droplet: `ssh root@sintaxlab.org`. If the SSH keys were set up properly it will just ask you to add the hostname to the list of known hosts and then it will automatically let you into the server.
2. Create a new tmux session: `tmux new -s sintaxlab`
3. Activate the Python virtual environment: `source /root/.pyenv/versions/3.9.0/envs/sintaxlab/bin/activate`
4. Move to the project directory `cd ~/HormoziGPT` and start the application: `streamlit run app.py`
5. Go and visit the website at [sintaxlab.org](https://sintaxlab.org)
