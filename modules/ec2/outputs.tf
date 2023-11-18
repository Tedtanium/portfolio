# Gives EC2 instance ID and private IP address for connectivity within the VPC upon instance creation

output "id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.host.id
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.host.private_ip
}
