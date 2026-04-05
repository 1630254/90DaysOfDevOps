output "ec2_public_ip" {
  description = "The public IP of the EC2 instance from the module"
  # This syntax 'module.<NAME>.<OUTPUT>' is the bridge
  value       = module.ec2_instance.public_ip
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance from the module"
  value       = module.ec2_instance.instance_id
}
