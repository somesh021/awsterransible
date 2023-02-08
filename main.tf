provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "ca-central-1"
  alias = "central"
}
resource "aws_security_group" "example_firstregion" {
  name        = "example_security_group"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "example_secondregion" {
  name        = "example_security_group"
  description = "Allow SSH access"
  provider = aws.central
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_firstregion" {
   ami           = "ami-00874d747dde814fa"
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.example_firstregion.id]
   key_name = "terraform-ansible"
   count = 5
   tags = {
    Name = "us-instance-${count.index}"
  }

}

resource "aws_instance" "ec2_secondregion" {
  ami = "ami-0dae3a932d090b3de"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example_secondregion.id]
  key_name = "ansible-terraform"
  count = 5
  tags = {
    Name = "ca-instance-${count.index}"
  }

  provider = aws.central
}
output "us-east-1_ips" {
  value = join(", ", aws_instance.ec2_firstregion.*.private_ip)
}
output "ca-central-1_ips" {
  value = join(", ", aws_instance.ec2_secondregion.*.private_ip)
}

