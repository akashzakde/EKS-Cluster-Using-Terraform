resource "aws_iam_role" "eks_role" {
  # Role name
  name = "eks-cluster"

  # Role for EKS cluster to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "EKS-Cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks-policy1" {
  # Policy arn to you want to apply & this policy is aws policy for eks cluster
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  #The role the policy should be applied to eks_cluster
  role = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks-policy2" {
  # Policy arn to you want to apply & this policy is aws policy for eks cluster
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  #The role the policy should be applied to eks_cluster
  role = aws_iam_role.eks_role.name
}


resource "aws_eks_cluster" "eks" {
  name = "EKS"
  # attach role which was created earlier
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    subnet_ids = [
      aws_subnet.public-subnet-1.id,
      aws_subnet.public-subnet-2.id,
      aws_subnet.private-subnet-1.id,
      aws_subnet.private-subnet-2.id,
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-policy1,
    aws_iam_role_policy_attachment.eks-policy1
  ]
}

output "endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}