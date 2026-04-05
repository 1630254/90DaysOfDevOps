resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  # Ensure the instance is reachable if in a public subnet
  associate_public_ip_address = true

  tags = {
    Name        = "${var.project_name}-ec2-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}
