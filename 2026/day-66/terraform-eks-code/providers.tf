terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-east-1"
}

# Fetch cluster details AFTER EKS is created
data "aws_eks_cluster" "terraweek" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "terraweek" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

# Configure Kubernetes provider to talk to your EKS cluster
provider "kubernetes" {
  host                   = data.aws_eks_cluster.terraweek.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.terraweek.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.terraweek.token
}
