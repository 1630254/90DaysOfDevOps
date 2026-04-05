variable "vpc_id" {
  description = "The ID of the VPC where the SG will be created"
  type        = string
}

variable "ingress_ports" {
  description = "List of ports to open for ingress"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}