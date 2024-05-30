terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-02bf8ce06a8ed6092"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }
}
