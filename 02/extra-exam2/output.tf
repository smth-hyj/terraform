output "amiID" {
  value = data.aws_ami.amazonLinux.id
  description = "ami ID print"
}