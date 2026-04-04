# Fetch available AZs in the current region
data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  # Using the first two available AZs
  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  
  # Subnet layout
  private_subnets = [
    cidrsubnet(var.vpc_cidr, 8, 1), 
    cidrsubnet(var.vpc_cidr, 8, 2)
  ]
  public_subnets  = [
    cidrsubnet(var.vpc_cidr, 8, 101), 
    cidrsubnet(var.vpc_cidr, 8, 102)
  ]

  # NAT Gateway configuration for private subnet internet access
  enable_nat_gateway = true
  single_nat_gateway = true # Cost-optimization: one NAT for all private subnets

  enable_dns_hostnames = true

  # Essential tags for EKS Load Balancer Controller discovery
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }

  tags = {
    Environment = "dev"
    Project     = "TerraWeek"
    ManagedBy   = "Terraform"
  }
}
