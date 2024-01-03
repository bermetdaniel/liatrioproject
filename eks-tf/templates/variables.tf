### VPC ###
variable "vpc_cidr" {
    type = string
    description = "vpc cidr block"
}

variable "public_access_cidr" {
    type = string
    description = "open cidr block"
}

variable "public_subnets_range" {
    type = list
    description = "public_subnets cidr"
}

variable "private_subnets_range" {
    type = list
    description = "private_subnets cidr"
}

### EKS ###
variable cluster_name {
  type    = string
  description = "the name of the cluster"
}

variable "eks_version" {
    type = string
    description = "the version of the cluster"
}

### Self-Managed Workers Node Group ###
variable "instance_type" {
  type        = string
  description = "eks cluster default instance type"
}

# variable "instance_key_pair" {
#   type        = string
#   description = "worker nodes instances key pair"
# }

variable "desired_capacity" {
  type        = number
  description = "EKS cluster desired number of worker nodes"
}

variable "max_size" {
  type        = number
  description = "EKS cluster max number of worker nodes"
}

variable "min_size" {
  type        = number
  description = "EKS cluster min number of worker nodes"
}

variable "spot_allocation_strategy" {
  type        = string
  description = "EKS cluster allocation strategy for spot instances"
}

variable "on_demand_base_capacity" {
  type        = number
  description = "Base number of on-demand EC2-instances"
}

variable "on_demand_percentage_above_base_capacity" {
  type        = number
  description = "Percentage of on-demand EC2-instances"
}

variable "volume_size" {
  type        = number
  description = "EBS volume size"
}

variable "volume_type" {
  type        = string
  description = "EBS volume type"
}

### ECR ###
variable "jenkins_master_repo" {
  type        = string
  description = "Jenkins-master ECR repo name"
}

variable "app_repo" {
  type        = string
  description = "App ECR repo name"
}