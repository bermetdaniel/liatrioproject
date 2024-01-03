##### EKS Cluster #####
resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.cluster_name}"
  role_arn = "${aws_iam_role.eks-cluster-role.arn}"
  version = "${var.eks_version}"
  vpc_config {
    subnet_ids = "${aws_subnet.eks-public-sub.*.id}"
    security_group_ids = ["${aws_security_group.eks-master-sg.id}"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}

### Master Node Security Group For EKS ###
resource "aws_security_group" "eks-master-sg" {
  name        = "${var.cluster_name}-eks-master-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.eks-vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-eks-master-sg"
  }
}


##### Worker Node Group Security Group #####
resource "aws_security_group" "eks-worker-sg" {
  name        = "${var.cluster_name}-worker-nodes-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.eks-vpc.id}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                                        = "${var.cluster_name}-worker-nodes-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

### Worker Node Security Group Rules ###
resource "aws_security_group_rule" "ingress-self" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks-worker-sg.id}"
  source_security_group_id = "${aws_security_group.eks-worker-sg.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress-cluster-https" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-worker-sg.id}"
  source_security_group_id = "${aws_security_group.eks-master-sg.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress-cluster-others" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-worker-sg.id}"
  source_security_group_id = "${aws_security_group.eks-master-sg.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingreass-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-master-sg.id}"
  source_security_group_id = "${aws_security_group.eks-worker-sg.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress-public-ssh" {
  description       = "Allow pods to be accessed via SSH"
  security_group_id = "${aws_security_group.eks-worker-sg.id}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress-public-HTTP" {
  description       = "Allow pods to be accessed via HTTP"
  security_group_id = "${aws_security_group.eks-worker-sg.id}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress-public-HTTPS" {
  description       = "Allow pods to be accessed via HTTPS"
  security_group_id = "${aws_security_group.eks-worker-sg.id}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

### AMI For Worker Nodes ###
data "aws_ami" "eks-worker-ami" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_version}-v*"]
  }
  most_recent = true
  owners      = ["amazon"]
}

### Bootstrap User Data For Worker Nodes ###
locals {
  node_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-cluster.certificate_authority.0.data}' '${var.cluster_name}'
USERDATA
}

### Launch Template For Worker Nodes ###
resource "aws_launch_template" "eks-worker-nodes" {
  image_id               = "${data.aws_ami.eks-worker-ami.id}"
  instance_type          = "${var.instance_type}"
  name_prefix            = "${var.cluster_name}-lt"
  vpc_security_group_ids = ["${aws_security_group.eks-worker-sg.id}"]
  user_data              = "${base64encode(local.node_userdata)}"
  # key_name               = "${var.instance_key_pair}"
  update_default_version = true
  description = "Amazon EKS self-managed nodes"
  iam_instance_profile {
    arn = "${aws_iam_instance_profile.worker-nodes.arn}"
  }
  lifecycle {
    create_before_destroy = true
  }
  block_device_mappings {
    device_name = "/dev/xvda"
    no_device = true

    ebs {
      volume_size = 30
      volume_type = "gp2"
      delete_on_termination = true
      }
    }
    tags = {
        Name = "${var.cluster_name}-template"
    }
}

### AutoScaling Group For Worker Nodes ###
resource "aws_autoscaling_group" "eks-worker-nodes" {
  desired_capacity    = "${var.desired_capacity}"
  max_size            = "${var.max_size}"
  min_size            = "${var.min_size}"
  name                = "${var.cluster_name}"
  vpc_zone_identifier = "${aws_subnet.eks-public-sub.*.id}"

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 1
      on_demand_percentage_above_base_capacity = 50
      spot_allocation_strategy                 = "${var.spot_allocation_strategy}"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.eks-worker-nodes.id}"
      }
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }
  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEBSCSIDriverPolicy
  ]
}

### Configure Kubernetes ConfigMaps To Permit The Nodes To Register ###
locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks-worker-role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}

resource "local_file" "config-map" {
  content  = "${local.config_map_aws_auth}"
  filename = "./files/config_map_aws_auth.yaml"
}

