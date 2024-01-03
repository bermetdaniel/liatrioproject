### Terraform AWS EKS Cluster ### 
# Created by Bermet #


##### This part of the project presents the creation of the EKS cluster in AWS using Terraform. #####



### Terraform ###
Engineers use Terraform as an infrastructure as code tool to define both cloud and on-premises resources in human-readable configuration files that can be versioned, reused, and shared. Terraform enables a consistent workflow to provision and manage infrastructure throughout its lifecycle. Terraform can be useful in managing tasks from low-level compute, storage, and networking resources to high-level components like DNS entries and Kubernetes objects.

### Kubernetes ###
Kubernetes, or K8s, is an open-source platform designed to automate deployment, scaling, and management of containerized applications. It helps simplify container management by grouping application containers into logical units, making them easier to discover and manage. Developed with input from the community, Kubernetes draws on Google's 15 years of experience running production workloads to offer best-of-breed practices for container orchestration.


The project can be found and cloned in the next [GitHub repo](https://github.com/bermetdaniel/liatrio.git/eks-tf).

### The fully functioned EKS cluster is provisioned using terraform with the next parameters: ###
- Uses Kubernetes version v1.23
- Contains on-demand t3.medium instance along with the mixed spot and on-demand instances
- Contain multi-AZ nodes for high-availability
- Creates new VPC with unique CIDR
- VPC has 3 public subnets and 3 private subnets
- Kubernetes cluster is placed in the public subnets, but private subnets used for RDS communication
- Security Groups are locked down to minimal permissive rules (SSH, web access, node ports, etc.)
- Installs and validates Ingress-nginx controller
- Creates IAM Users for the nodes and policies to access ECR and the Parameter Store

### Before starting the cluster it is important to complete the next steps: ###
- Configure an AWS CLI and have the kubectl tool installed on the machine.
- Configure eksctl tool on the machine.
- Configure a user or assume a role with right set of permissions.
- Configure all the needs of the cluster and write them down either into the "dev.tfvars" or "prod.tfvars" file.

### Helpful links: ###
- Configure AWS CLI - [AWS_CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- Assume role  -  [Assume_role](https://aws.amazon.com/premiumsupport/knowledge-center/iam-assume-role-cli/)
- Install kubectl -  [Kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)
- Install eksctl - [Eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

## Instructions
#### Note: Makefile is used to automate deployment of the code.

1. Clone source code repository to your local machine and navigate to directory with terraform files:
```
- git clone https://github.com/bermetdaniel/liatrio.git/eks-tf
- cd module
```

2.  Review AWS EKS resources to be created by executing the command:
```
- make eks-init-plan
```

3. To create all the resources and dependancies execute the next command:\
   This step will also:
   - Configure kubectl so that you can connect to an Amazon EKS cluster
   - Create "aws-auth ConfigMap" to allow nodes to join to EKS cluster
   - Configure the eksctl tool to install the aws-ebs-csi-driver add-on, to have the volume binding configured  
```
- make eks-apply
```

4. To create the ingress-nginx resource and dependancies execute the next command:\
   This step will also:
    - Install and configure ingress-nginx controller in the cluster
    - Install and configure the NLB in the created VPC
```
- make eks-ingress
```

5. To install everything by running one command:
```
- make all
```

6. To update everything after changes made:
```
- make eks-update
```

7. To delete ingress-nginx and dependencies:
```
- make eks-ingress-delete
```

8. To delete EKS cluster and dependencies:
```
- make eks-delete
```

9. To delete everything by rinning one command:
```
- make delete-all
```
