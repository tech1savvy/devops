output "public-ip-address" {
  value = aws_instance.this.public_ip
}

output "private-ip-address" {
  value = aws_instance.this.private_ip
}
