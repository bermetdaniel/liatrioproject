### Provider ###
provider "aws" {
  region = var.region_main
}

### Backend ###
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
terraform {
  backend "s3" {
    bucket = "liatrio-bema"
    key    = "Liatrio/terraform.tfstate"
    region = "us-west-1"
    # dynamodb_table = "module.remote_backend.dynamodb_table_name"
  }
}
# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }

### Modules ###
module "vpc" {
  source = "../templates"

  ### VPC ###
  vpc_cidr              = var.vpc_cidr_main
  public_access_cidr    = var.public_access_cidr_main
  public_subnets_range  = var.public_subnets_range_main
  private_subnets_range = var.private_subnets_range_main

  ### EKS ###
  cluster_name = var.cluster_name_main
  eks_version  = var.eks_version_main

  ### Self-Managed Workers Node Group ###
  instance_type = var.instance_type_main
  # instance_key_pair                        = var.instance_key_pair_main
  desired_capacity                         = var.desired_capacity_main
  max_size                                 = var.max_size_main
  min_size                                 = var.min_size_main
  spot_allocation_strategy                 = var.spot_allocation_strategy_main
  on_demand_base_capacity                  = var.on_demand_base_capacity_main
  on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity_main
  volume_size                              = var.volume_size_main
  volume_type                              = var.volume_type_main

  ### ECR ###
  jenkins_master_repo = var.jenkins_master_repo_main
  app_repo            = var.app_repo_main
}

module "SSM" {
  source = "../SSM"
  ### SSM ###
  jenkins_admin_user  = var.jenkins_admin_user_main
  jenkins_admin_pass  = var.jenkins_admin_pass_main
  jenkins_build_user  = var.jenkins_build_user_main
  jenkins_build_pass  = var.jenkins_build_pass_main
  jenkins_read_user   = var.jenkins_read_user_main
  jenkins_read_pass   = var.jenkins_read_pass_main
  jenkins_github_user = var.jenkins_github_user_main
  jenkins_github_key  = var.jenkins_github_key_main
}
