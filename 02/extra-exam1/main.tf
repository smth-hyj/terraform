# 1) public Subnet 만들기
# 2) Routing Table 만들고  Public Subnet 연결하기

provider "aws" {
    region = "us-east-2"  
}

resource "aws_vpc" "myVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "myVPC"
  }
}

resource "aws_subnet" "MyPubSubnet" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "MyPubSubnet"
  }
}

# Internet Gateway 생성 

resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "myIGW"
  }
}

resource "aws_route_table" "myPubRT" {
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }

  tags = {
    Name = "myRT"
  }
}

resource "aws_route_table_association" "myRTass" {
  subnet_id      = aws_subnet.MyPubSubnet.id
  route_table_id = aws_route_table.myPubRT.id
}

# Security Group 생성
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow htpp inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  tags = {
    Name = "allow_http"
  }
}

# # SECURITY 그룹의 ingress rule
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# SECURITY 그룹의 egress group
resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# EC2 생성
# * ami: AMAZON linux 
resource "aws_instance" "myWEB" {
  ami           = "ami-0ca2e925753ca2fb4"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.MyPubSubnet.id

  user_data_replace_on_change = true
  user_data = <<EOF
  #!/bin/bash
  yum -y install httpd
  echo "my WEB" > /var/www/html/index.html
  ssytemctl enable --now httpd
  echo 
  EOF

  tags = {
    Name = "myWEB~"
  }
}


# Public Routing Table 생성

# resource "aws_route_table" "myPubRT" {
#   vpc_id = aws_vpc.myVPC.id

#   route {
#     cidr_block = "10.0.1.0/24"
#     gateway_id = aws_internet_gateway.example.id
#   }

#   route {
#     ipv6_cidr_block        = "::/0"
#     egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
#   }

#   tags = {
#     Name = "example"
#   }
# }