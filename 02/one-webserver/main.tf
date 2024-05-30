provider "aws" {
  region = "us-east-2"
}


resource "aws_security_group" "allow_8080" {
  name        = "${var.mySGname}"
  description = "${var.mySGname} inbound traffic and all outbound traffic"

  tags = {
    Name = "${var.mySGname}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_8080" {
  security_group_id = aws_security_group.allow_8080.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_instance" "example" {
  ami                    = "ami-0f30a9c3a48f3fa79"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_8080.id]

  user_data_replace_on_change = true
  user_data                   = <<-EOF
                #!/bin/bash
                echo "hello,world" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF

  tags = {
    Name = "terraform-example"
  }
}

