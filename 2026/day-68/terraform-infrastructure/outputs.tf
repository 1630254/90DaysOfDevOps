output "instance_details" {
  description = "Map of instance names to their public IP addresses"
  value = {
    for i in range(length(aws_instance.web_servers)) :
    aws_instance.web_servers[i].tags["Name"] => aws_instance.web_servers[i].public_ip
  }
}
