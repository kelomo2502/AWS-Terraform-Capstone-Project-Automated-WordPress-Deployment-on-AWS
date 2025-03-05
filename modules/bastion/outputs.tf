output "bastion_instance_id" {
  value = aws_instance.bastion.id
}
output "bastion_private_ip" {
  description = "Private IP address of the bastion host"
  value       = aws_instance.bastion.private_ip
}

output "bastion_sg" {
  description = "Security Group of the bastion host"
  value       = aws_security_group.bastion_sg.id
}
