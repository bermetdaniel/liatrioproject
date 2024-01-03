### EKS IAM Cluster Role ###
resource "aws_iam_role" "eks-cluster-role" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = {
    tag-key = "${var.cluster_name}-cluster-role"
  }
}

### IAM Policies For Cluster Role ###
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks-cluster-role.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = "${aws_iam_role.eks-cluster-role.name}"
}

### EKS IAM Worker Role ###
resource "aws_iam_role" "eks-worker-role" {
  name = "${var.cluster_name}-worker-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = {
    tag-key = "${var.cluster_name}-worker-role"
  }
}

### Caller Identity ###
data "aws_caller_identity" "current" {}

### ECR Policy Creation for Jenkins_master ###
resource "aws_iam_policy" "ECR-policy" {
  name        = "ECR-Policy"
  description = "Allows access to ECR resources"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:PutImageTagMutability",
                "ecr:StartImageScan",
                "ecr:DescribeImageReplicationStatus",
                "ecr:ListTagsForResource",
                "ecr:UploadLayerPart",
                "ecr:ListImages",
                "ecr:BatchGetRepositoryScanningConfiguration",
                "ecr:CompleteLayerUpload",
                "ecr:TagResource",
                "ecr:DescribeRepositories",
                "ecr:BatchCheckLayerAvailability",
                "ecr:ReplicateImage",
                "ecr:GetLifecyclePolicy",
                "ecr:PutLifecyclePolicy",
                "ecr:DescribeImageScanFindings",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:PutImageScanningConfiguration",
                "ecr:GetDownloadUrlForLayer",
                "ecr:PutImage",
                "ecr:UntagResource",
                "ecr:BatchGetImage",
                "ecr:DescribeImages",
                "ecr:StartLifecyclePolicyPreview",
                "ecr:InitiateLayerUpload",
                "ecr:GetRepositoryPolicy"
            ],
            "Resource": "arn:aws:ecr:*:${data.aws_caller_identity.current.account_id}:repository/*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "ecr:GetRegistryPolicy",
                "ecr:BatchImportUpstreamImage",
                "ecr:DescribeRegistry",
                "ecr:DescribePullThroughCacheRules",
                "ecr:GetAuthorizationToken",
                "ecr:PutRegistryScanningConfiguration",
                "ecr:GetRegistryScanningConfiguration"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

### IAM Policies For Worker Nodes ###
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eks-worker-role.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.eks-worker-role.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.eks-worker-role.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = "${aws_iam_role.eks-worker-role.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonSSMReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  role       = "${aws_iam_role.eks-worker-role.name}"
}

resource "aws_iam_role_policy_attachment" "ECR-policy" {
  policy_arn = "${aws_iam_policy.ECR-policy.arn}"
  role       = "${aws_iam_role.eks-worker-role.name}"
  depends_on = [aws_iam_policy.ECR-policy]
}

### Worker Node Group Instance Profile ###
resource "aws_iam_instance_profile" "worker-nodes" {
  name = "${var.cluster_name}-worker-nodes"
  role = "${aws_iam_role.eks-worker-role.name}"
}

