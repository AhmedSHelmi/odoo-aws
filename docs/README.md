# Odoo AWS Deployment with Terraform, Ansible, and Docker

## Overview
This project automates the deployment of Odoo ERP on AWS using Terraform for infrastructure management, Ansible for configuration management, and Docker for containerization.

## Setup Instructions

### 1. Prerequisites
- AWS account and credentials
- Terraform installed
- Ansible installed
- SSH key for accessing the AWS EC2 instance

### 2. Infrastructure Setup
1. Clone this repository:
    ```bash
    git clone <repository-url>
    cd odoo-aws-deployment
    ```

2. Navigate to the Terraform directory and initialize:
    ```bash
    cd terraform
    terraform init
    ```

3. Update the `terraform.tfvars` file with your AWS region and key pair name.

4. Plan and apply the Terraform configuration:
    ```bash
    terraform plan
    terraform apply
    ```

5. Note the EC2 instance public IP output by Terraform.

### 3. Configuration with Ansible
1. Update the Ansible inventory file with the EC2 public IP:
    ```bash
    ansible/inventory/hosts.ini
    ```

2. Run the Ansible playbook to configure Docker, PostgreSQL, and Odoo:
    ```bash
    ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/odoo-playbook.yml
    ```

### 4. Access Odoo
- Odoo should be accessible at `http://<EC2_PUBLIC_IP>:8069`

### 5. Clean Up
To clean up your environment, you can use the following commands:
- Terraform destroy:
    ```bash
    terraform destroy
    ```

- Docker cleanup:
    ```bash
    bash scripts/cleanup.sh
    ```
