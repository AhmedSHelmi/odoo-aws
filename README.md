# Odoo AWS Deployment with Terraform, Ansible, and Docker

## Overview
This project automates the deployment of the Odoo ERP system on AWS using **Terraform** for infrastructure provisioning, **Ansible** for configuration management, and **Docker** to containerize both the Odoo and PostgreSQL services.

## Prerequisites
Before you begin, make sure you have the following:

1. **AWS Account**: You will need valid AWS credentials with permissions to create EC2 instances, security groups, and other resources.
2. **Terraform**: Installed locally for managing infrastructure as code. [Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli).
3. **Ansible**: Installed locally for configuring the EC2 instance. [Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
4. **SSH Key**: An SSH key pair for accessing the AWS EC2 instance. You will need to reference this in the Terraform configuration.
5. **AWS CLI (optional)**: For managing AWS resources via the command line. [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

## Project Structure

```bash
odoo-aws-deployment/
│
├── terraform/               # Terraform files for infrastructure provisioning
│   ├── main.tf              # Defines VPC, subnets, security groups, and EC2 instance
│   ├── variables.tf         # Variable declarations
│   ├── outputs.tf           # Outputs from the Terraform deployment
│   ├── terraform.tfvars     # Variable values (e.g., region, key pair name)
│   └── provider.tf          # AWS provider configuration
│
├── ansible/                 # Ansible playbooks for setting up Odoo and PostgreSQL
│   ├── playbooks/
│   │   └── odoo-playbook.yml  # Playbook for installing Docker, Odoo, and PostgreSQL
│   ├── inventory/
│   │   └── hosts.ini        # Ansible inventory file (with EC2 instance IP)
│   └── roles/
│       ├── docker/          # Docker role tasks
│       ├── postgres/        # PostgreSQL role tasks
│       └── odoo/            # Odoo role tasks
│
├── docker/                  # Optional: Docker Compose file for local testing
│   └── docker-compose.yml
│
├── scripts/                 # Helper scripts
│   ├── bootstrap.sh         # Bootstrap script for installing Docker
│   └── cleanup.sh           # Cleanup script to remove Docker containers, images, etc.
│
├── docs/                    # Documentation files
│   └── README.md            # This file
│
└── .gitignore               # Git ignore file
```

## Step-by-Step Setup Guide

### 1. Clone the Repository
Start by cloning this repository to your local machine:

```bash
git clone <repository-url>
cd odoo-aws-deployment
```

### 2. Setup AWS Infrastructure with Terraform
Navigate to the `terraform/` directory to set up your AWS infrastructure:

```bash
cd terraform
```

1. **Initialize Terraform**:
   - This step downloads the required providers and sets up your workspace.

   ```bash
   terraform init
   ```

2. **Update Terraform Variables**:
   - Modify the `terraform.tfvars` file to include your AWS region and SSH key pair name:
   
   ```hcl
   region = "us-east-1"      # Update to your preferred region
   instance_type = "t2.micro" # Instance type for the EC2 instance
   key_name = "your-key-name" # Replace with your AWS SSH key name
   ```

3. **Plan and Apply the Infrastructure**:
   - Check the Terraform plan to ensure everything is set up correctly:

   ```bash
   terraform plan
   ```

   - Apply the configuration to create the resources:

   ```bash
   terraform apply
   ```

4. **Note the EC2 Public IP**:
   - After successful creation, Terraform will output the public IP address of the EC2 instance. You will need this for the next steps.

### 3. Configure Odoo with Ansible
Navigate to the `ansible/` directory to set up Docker and deploy Odoo on the EC2 instance:

```bash
cd ../ansible
```

1. **Update the Ansible Inventory**:
   - Open `inventory/hosts.ini` and replace `<EC2_PUBLIC_IP>` with the actual public IP of your EC2 instance output by Terraform.

   ```ini
   [odoo_server]
   <EC2_PUBLIC_IP> ansible_ssh_user=ec2-user ansible_ssh_private_key_file=~/.ssh/your-key.pem
   ```

2. **Run the Ansible Playbook**:
   - This command will install Docker on the EC2 instance, set up PostgreSQL as the database, and run Odoo in Docker containers:

   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/odoo-playbook.yml
   ```

### 4. Access Odoo
Once the playbook completes successfully, Odoo should be up and running. You can access it by opening your web browser and navigating to:

```
http://<EC2_PUBLIC_IP>:8069
```

### 5. Clean Up
When you're done with the deployment and want to tear down the environment:

1. **Destroy Terraform Infrastructure**:
   - Navigate back to the `terraform/` directory and destroy the AWS infrastructure:

   ```bash
   terraform destroy
   ```

2. **Remove Docker Containers** (Optional):
   - You can run the cleanup script to remove Docker containers, images, and volumes:

   ```bash
   bash scripts/cleanup.sh
   ```

## Optional: Local Testing with Docker Compose
If you want to test Odoo locally before deploying to AWS, you can use Docker Compose:

1. **Navigate to the `docker/` directory**:
   ```bash
   cd docker
   ```

2. **Run Docker Compose**:
   ```bash
   docker-compose up
   ```

3. **Access Odoo locally**:
   ```
   http://localhost:8069
   ```
