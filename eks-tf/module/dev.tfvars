### VPC ###
region_main                = "us-west-1"
vpc_cidr_main              = "10.30.0.0/16"
public_access_cidr_main    = "0.0.0.0/0"
public_subnets_range_main  = ["10.30.1.0/24", "10.30.2.0/24", "10.30.3.0/24"]
private_subnets_range_main = ["10.30.7.0/24", "10.30.8.0/24", "10.30.9.0/24"]

### EKS ###
cluster_name_main = "Liatrio"
eks_version_main  = "1.23"

### Self-Managed Workers Node Group ###
instance_type_main = "t3.medium"
# instance_key_pair_main        = "_eks-dev_new_key"
desired_capacity_main         = "2"
max_size_main                 = "5"
min_size_main                 = "1"
spot_allocation_strategy_main = "lowest-price"
### [lowest-price, capacity-optimized, capacity-optimized-prioritized, price-capacity-optimized] ###
on_demand_base_capacity_main                  = "1"
on_demand_percentage_above_base_capacity_main = "50"
volume_size_main                              = "30"
volume_type_main                              = "gp2"

### ECR ###
jenkins_master_repo_main = "jenkins-master"
app_repo_main            = "liatrio"

### SSM ###
jenkins_admin_user_main  = "bermetdaniel"
jenkins_admin_pass_main  = "123456789Ps"
jenkins_build_user_main  = "bermetdaniel"
jenkins_build_pass_main  = "123456789Ps"
jenkins_read_user_main   = "bermetdaniel"
jenkins_read_pass_main   = "123456789Ps"
jenkins_github_user_main = "bermetdaniel"
jenkins_github_key_main  = <<EOT
EOT
