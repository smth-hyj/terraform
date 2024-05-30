# ec2 인스턴스 AMI ID를 위한 데이터 리소스 조회

data "aws_ami" "amazonLinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] 
}


resource "aws_instance" "myInstance" {
  ami           = data.aws_ami.amazonLinux.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
