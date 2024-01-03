# The Project from Bermet for Liatrio #

## Technologies Used ##

### AWS ###
(Amazon Web Services) is a cloud computing platform that provides a wide range of services and tools for building and deploying cloud-based applications and services.

### Terraform ### 
Terraform is a cloud-agnostic IaC tool for building, changing, and versioning infrastructure safely and efficiently.

### Kubernetes ### 
Kubernetes is a portable, extensible, open-source container-orchestration tool for managing containerized workloads and services.

### Docker ###
Docker is a tool for developing, shipping, and running applications in containers.

### Jenkins ###
A continuous integration and delivery automation tool for software development projects.

### AWS CLI ###
AWS CLI is a command-line interface tool for interacting with AWS services and resources from the terminal.

### kubectl ###
kubectl is a command-line tool for deploying and managing applications on Kubernetes clusters.

### helm ###
helm is a package manager for Kubernetes applications with reusable deployment configurations.
Additionally, the configuration files include AWS resources such as Elastic Container Registry (ECR), Elastic Kubernetes Service (EKS), IAM roles and policies, and security groups.



## The Prerequisites  ##

### A valid AWS account ##

### AWS CLI installed and configured with your AWS credentials ###

### Terraform installed ###

### kubectl installed ###

### helm installed ###

### docker ###



## Instructions ##
#### Note: Makefile is used to automate deployment of the code. ####

1. Clone source code repository to your local machine and navigate to directory with terraform files:
```
- git clone https://github.com/bermetdaniel/liatrio.git/eks-tf
```

2. Single command to launch the environment, deploy the jenkins master and deploy the application using helm
```shell
make all
```


3. In case you do not have access to the ssh keys used to access the github, you might need to deploy the app without using Jenkins 
```shell
make test
```

4. Single command to destroy the environment with all dependancies 
```shell
make delete-all
```


## Overview ##
This README provides an overview of the Terraform configuration files for deploying an example application to an AWS Kubernetes cluster using Docker containers. It explains the overview of each section, including the creation of resources such as the AWS ECR container registry, EKS cluster, EKS node group, and VPC with subnets, security groups, and gateways. To use this configuration, you must have an AWS account, AWS CLI, Terraform, kubectl, and helm installed. You need customize the variables in the all dev.tfvars, and Makefiles. Also you need adjust the resources to suit your specific requirements.



## APP ##
Example App in Docker Image
This Docker image runs a web application that returns a JSON message and a timestamp. The image is based on the python:3.9-alpine image and installs the Werkzeug,Flask package and copies the app.py file to the /app directory in the container. Also the app directory contains the k8s-chart with the helm templates that are dynamic. The Makefile can be adjusted by changing the variables inside. Also, to make sure that aplication can be deployed in three different enviroments, the configs are included, where you can personaly customize the variables for each enviroment. If you have a hosted zone in your account hosted in Route53, adding the hostname will automatically create a DNS record for it.

### appname ###
appname is the name of the app, that has to match the ecr repo name specified in dev.tfvars file in the eks-tf/module directory.

### region ###
region is the variable that has to match the region for the cluster creation and S3 bucket for better performance

### hosted_zone ###
specify the hosted zone from your Route53 is you have one to have the DNS record created for you

### stage ###
the default stage is "dev" but the configs for other stages are used by Jenkins depending on the github branch scaned 

### account ###
extracts the account number

### configs ###
includes variables from the configs directory

### hosted_zone_id ###
extract the hosted zone ID from your account for creating the DNS record

### elb_hosted_zone_id ###
extract the elb ID created by nginx ingress-controller from your account for creating the DNS record

### elb_url ###
extracts the elb url for creating the DNS record

### Manual instuctions for deploying app separatelly ###

1. Change the directory into the App
```shell
cd app
```

2. Single command to deploy the app using helm and test it by checking the hostname link
```shell
make test
```

3. Single command to containirize the app, and deploy it using helm with testing it by checking the hostname link
```shell
make all
```

4. Single command to destroy the environment with all dependancies 
```shell
make delete-all
```



## eks-tf ##
This is the directory the contains four reusable modules created using terraform code. The modules are used to deploy 53 resources which configure the complex cloud-based system in AWS with the EKS deployment, ensuring the high-availability, durability, scalability, security and cost-efficiency. The mix of spot and on-demand self managed worker nodes for EKS save costs. The attached AWS managed and inline policies ensure the security. SSM creates the parameters automatically from the local variable values. The current directory also contains the detailed decription of all of the resources in a separate README.md.

### Manual instuctions for deploying resources separatelly ###

1. Change the directory into the eks-tf/remote_backend. Make sure to go through all the the variables values in dev.tfvars file.
```shell
cd eks-tf/remote_backend
```

2. Change the directory into the eks-tf/module. Make sure to go through all the the variables values in dev.tfvars file. If you are not planning to use jenkins-master then there is no need to create the SSM values and it can be left empty.
```shell
cd eks-tf/module
```

3. Single command to deploy the entire infrastructure including backend configuration 
```shell
make both
```

4. Single command to deploy the entire infrastructure if you have the bucket already created and the key is specified
```shell
make all
```

5. Single command to destroy the environment with all dependancies 
```shell
make delete-both
```



## jenkins-master ##
It is the directory the includes the files to create an docker image for the Jenkin-master with the needed plugins, and then deploy it into the cluster. The test is done by curl the previously created DNS record poiniting to a hostname. The Makefile can be fully customized according to your needs.

### repo ###
it is the name of the repo, that has to match the ecr repo name specified in dev.tfvars file in the eks-tf/module directory.

### region ###
region is the variable that has to match the region for the cluster creation and S3 bucket for better performance

### namespace ###
the name of the namespace for deploying jenkins-master

### version ###
the version of the image for deployed and stored in the ECR

### hostname ###
the hostname that will be used to access jenkins-master via browser

### hosted_zone ###
specify the hosted zone from your Route53 is you have one to have the DNS record created for you

### account ###
extracts the account number

### hosted_zone_id ###
extract the hosted zone ID from your account for creating the DNS record

### elb_hosted_zone_id ###
extract the elb ID created by nginx ingress-controller from your account for creating the DNS record

### elb_url ###
extracts the elb url for creating the DNS record

### Manual instuctions for deploying app separatelly ###

1. Change the directory into the App
```shell
cd jenkins-master
```

2. Single command to deploy the jenkins-master and test it by checking the hostname link
```shell
make test
```

3. Single command to containirize the app, and deploy it using helm with testing it by checking the hostname link
```shell
make all
```

4. Single command to destroy the environment with all dependancies 
```shell
make delete-all
```
nstalled and configured with the appropriate credentials.




## Useful Links ##

### Terraform documentation: https://www.terraform.io/docs/index.html ###

### Kubernetes documentation: https://kubernetes.io/docs/home/ ###

### Docker documentation: https://docs.docker.com/ ###

### AWS documentation: https://aws.amazon.com/documentation/ ###

### AWS CLI documentation: https://docs.aws.amazon.com/cli/index.html ###

### kubectl documentation: https://kubernetes.io/docs/tasks/tools/ ###

### helm documentation: https://helm.sh/docs/ ###

### Jenkins documentation: https://www.jenkins.io/doc/ ###

### Elastic Container Registry (ECR) documentation: https://aws.amazon.com/ecr/ ###

### Elastic Kubernetes Service (EKS) documentation: https://aws.amazon.com/eks/ ###

### IAM roles and policies documentation: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html ###

### Security groups documentation: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html ###
