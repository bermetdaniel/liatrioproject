### VPC ###
variable "region_main" {
  type        = string
  description = "private_subnets cidr"
}

variable "vpc_cidr_main" {
  type        = string
  description = "vpc cidr block"
}

variable "public_access_cidr_main" {
  type        = string
  description = "open cidr block"
}

variable "public_subnets_range_main" {
  type        = list(any)
  description = "public_subnets cidr"
}

variable "private_subnets_range_main" {
  type        = list(any)
  description = "private_subnets cidr"
}



### EKS ###
variable "cluster_name_main" {
  type        = string
  description = "the name of the cluster"
}

variable "eks_version_main" {
  type        = string
  description = "the version of the cluster"
}

### Self-Managed Workers Node Group ###
variable "instance_type_main" {
  type        = string
  description = "eks cluster default instance type"
}

# variable "instance_key_pair_main" {
#   type        = string
#   description = "worker nodes instances key pair"
# }

variable "desired_capacity_main" {
  type        = number
  description = "EKS cluster desired number of worker nodes"
}

variable "max_size_main" {
  type        = number
  description = "EKS cluster max number of worker nodes"
}

variable "min_size_main" {
  type        = number
  description = "EKS cluster min number of worker nodes"
}

variable "spot_allocation_strategy_main" {
  type        = string
  description = "EKS cluster allocation strategy for spot instances"
}

variable "on_demand_base_capacity_main" {
  type        = number
  description = "Base number of on-demand EC2-instances"
}

variable "on_demand_percentage_above_base_capacity_main" {
  type        = number
  description = "Percentage of on-demand EC2-instances"
}

variable "volume_size_main" {
  type        = number
  description = "EBS volume size"
}

variable "volume_type_main" {
  type        = string
  description = "EBS volume type"
}



### SSM ###
variable "jenkins_admin_user_main" {
  description = "Value for the jenkins-admin-user parameter"
  type        = string
}

variable "jenkins_admin_pass_main" {
  description = "Value for the jenkins-admin-pass parameter"
  type        = string
}

variable "jenkins_build_user_main" {
  description = "Value for the jenkins-build-user parameter"
  type        = string
}

variable "jenkins_build_pass_main" {
  description = "Value for the jenkins-build-pass parameter"
  type        = string
}

variable "jenkins_read_user_main" {
  description = "Value for the jenkins-read-user parameter"
  type        = string
}

variable "jenkins_read_pass_main" {
  description = "Value for the jenkins-read-pass parameter"
  type        = string
}

variable "jenkins_github_user_main" {
  description = "Value for the jenkins-github-user parameter"
  type        = string
}

variable "jenkins_github_key_main" {
  description = "Value for the jenkins-github-key parameter"
  type        = string
}


### ECR ###
variable "jenkins_master_repo_main" {
  type        = string
  description = "Jenkins-master ECR repo name"
}

variable "app_repo_main" {
  type        = string
  description = "Jenkins-master ECR repo name"
}