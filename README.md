# Terraform VM Infrastructure

This project contains Terraform code to create a configurable number of virtual machines (VMs) on AWS. The VMs will be connected within the same VPC and run a round-robin ping test between each other, with the results aggregated as an output.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) version 1.x
- AWS CLI configured with your AWS account
- An AWS account with the necessary permissions (EC2, VPC, etc.)

## How to Use

1. Clone the repository:

   git clone https://github.com/username/terraform-vm-infrastructure.git
   cd terraform-vm-infrastructure

2. Initialize Terraform:
    **terraform init**

3. Create a **terraform.tfvars** file or use the example one provided (example.tfvars). This file should contain the necessary variables, like the number of VMs, instance types, and AMI.

4. Apply the configuration:
    **terraform apply -var-file="example.tfvars"**

5. To destroy the infrastructure after testing:
    **terraform destroy -var-file="example.tfvars"**

## Variables

- `vm_count`: The number of VMs to create (between 2 and 100).
- `vm_flavor`: The EC2 instance type for the VMs (e.g., `t2.micro`).
- `vm_image`: The AMI ID to use for the VMs.
- `vpc_cidr`: CIDR block for the VPC.
- `subnet_cidr`: CIDR block for the subnet.

## Outputs
- `ping_results`: Aggregated ping test results between the VMs.

## Example tfvars File
An example of a example.tfvars file:

        # example.tfvars
        vm_count    = 3
        vm_flavor   = "t2.micro"
        vm_image    = "ami-12345678"
        vpc_cidr    = "10.0.0.0/16"
        subnet_cidr = "10.0.1.0/24"
        
Replace the values with your own AWS configuration before running the terraform apply command.
