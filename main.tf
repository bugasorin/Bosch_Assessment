provider "aws" {
  region  = var.aws_region
  profile = "Dev"
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

}

resource "aws_security_group" "allow_ping" {
  name        = "allow_ping"
  description = "Allow ICMP traffic for pinging between VMs"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "vm" {
  count                  = var.vm_count
  ami                    = var.vm_image
  instance_type          = var.vm_flavor
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_ping.id]

  tags = {
    Name = "VM-${count.index}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'admin_password=${random_password.vm_pass[count.index].result}' > /home/admin/admin_password"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.sshkey.private_key_pem
    host        = self.public_ip
  }

  #provisioner "remote-exec" {
  #  inline = [
  #    "ping -c 1 ${element(aws_instance.vm.*.private_ip, (count.index + 1) % var.vm_count)}"
  #  ]
  #}
}

resource "random_password" "vm_pass" {
  count   = var.vm_count
  length  = 16
  special = true
}

resource "tls_private_key" "sshkey" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "awskeypair" {
  key_name   = "ssh-key"
  public_key = tls_private_key.sshkey.public_key_openssh
}

resource "null_resource" "ping_test" {
  count = var.vm_count

  provisioner "local-exec" {
    command = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.vm[count.index].public_ip} 'ping -c 1 ${element(aws_instance.vm.*.private_ip, (count.index + 1) % var.vm_count)}'"
  }

  depends_on = [aws_instance.vm]
}
