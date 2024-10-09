variable "aws_region" {
  description = "Define region of deployment"
  default     = "eu-central-1"
}

variable "cidr_block" {
  description = "value for cidr"
  default     = "10.0.0.0/16"

}

variable "vm_count" {
  description = "Number of default VMs to be created"
  default     = "3"

}

variable "vm_image" {
  description = "Default image to be used when creating the VM"
  default     = "ami-0084a47cc718c111a"

}

variable "vm_flavor" {
  description = "Type of AWS instance"
  default     = "t2.micro"

}
