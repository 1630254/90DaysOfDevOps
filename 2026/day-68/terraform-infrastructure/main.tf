resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows access from anywhere; limit this to your IP for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "server_roles" {
  default = ["web-server", "app-server", "db-server"]
}

resource "aws_instance" "web_servers" {
  count         = 3
  ami           = "ami-053b0d53c279acc90" # Ubuntu 22.04 LTS in us-east-1
  instance_type = "t2.micro"
  key_name      = "demoKeyPair"

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = var.server_roles[count.index]
  }

}
