provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "ca-central-1"
  alias = "central"
}
resource "aws_instance" "ec2_firstregion" {
   ami           = "ami-00874d747dde814fa"
   instance_type = "t2.micro"
   count = 5
}

resource "aws_instance" "ec2_secondregion" {
  ami = "ami-0dae3a932d090b3de"
  instance_type = "t2.micro"
  count = 5
  provider = aws.central
}