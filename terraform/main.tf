provider "aws" {
  region     = var.aws_region
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-ansible-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "random-pass" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = "faacicd"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = file("scripts/userdata.sh")

  tags = {
    Name = var.instance_name
  }
}

output "ec2_public_ip" {
  value = aws_instance.random-pass.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.random-pass.public_dns
}


resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/../ansible/inventory.tpl", {
    all_ips = [for i in aws_instance.random-pass.* : i.public_ip]
  })
  filename = "${path.module}/../ansible/inventory.ini"
}

