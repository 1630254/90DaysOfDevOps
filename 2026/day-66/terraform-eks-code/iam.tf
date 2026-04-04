########################################
# IAM integration for EKS access
########################################

# Look up the IAM user you want to grant access
data "aws_iam_user" "user1" {
  user_name = "user1"
}

# Register the IAM user with the EKS cluster
resource "aws_eks_access_entry" "user1" {
  cluster_name  = module.eks.cluster_name
  principal_arn = data.aws_iam_user.user1.arn
  type          = "STANDARD"
}

# Associate AmazonEKSAdminPolicy with the IAM user
resource "aws_eks_access_policy_association" "user1_admin" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = aws_eks_access_entry.user1.principal_arn

  access_scope {
    type = "cluster"
  }
}

# Associate AmazonEKSClusterAdminPolicy with the IAM user
resource "aws_eks_access_policy_association" "user1_cluster_admin" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_eks_access_entry.user1.principal_arn

  access_scope {
    type = "cluster"
  }
}
