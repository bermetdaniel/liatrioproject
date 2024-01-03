##### EKS #####

### Initialize Backend ###
backend:
	$(MAKE) -C ./remote_backend all

### Plan EKS ###
eks-init-plan:
	terraform init && terraform plan -var-file="dev.tfvars"

### Create EKS And Install Add-On ###
eks-apply:
	terraform apply -var-file="dev.tfvars" -auto-approve
	aws eks update-kubeconfig --name $(shell grep '^cluster_name_main' dev.tfvars | awk -F= '{print $$2}' | tr -d '[:space:]')
	kubectl apply -f files/config_map_aws_auth.yaml
	sleep 100
	kubectl get nodes
	eksctl create addon --name aws-ebs-csi-driver --version v1.16.0-eksbuild.1 --cluster $(shell grep '^cluster_name_main' dev.tfvars | awk -F= '{print $$2}' | tr -d '[:space:]')

### Create Ingress-Nginx ###
eks-ingress:	
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/aws/deploy.yaml
	kubectl -n ingress-nginx patch service ingress-nginx-controller -p '{"spec":{"externalTrafficPolicy":"Cluster"}}'
	kubectl -n ingress-nginx describe svc ingress-nginx-controller
	kubectl get nodes


##### EKS ALL #####
all: eks-init-plan eks-apply eks-ingress	


### Update EKS ###
eks-update:
	terraform apply -var-file="dev.tfvars" -auto-approve
	aws eks update-kubeconfig --name $(shell grep '^cluster_name_main' dev.tfvars | awk -F= '{print $$2}' | tr -d '[:space:]')
	kubectl get nodes

### Destroy Ingress-Nginx ### 
# It is sugested to delete ingress-nginx first, since it initially creates a network load balancer, #
#  which then becomes a dependancy of the VPC, which causes an error when destroying the VPC #
eks-ingress-delete:
	- kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/aws/deploy.yaml

### Destroy EKS And Resources ###
eks-delete:
	terraform destroy -var-file="dev.tfvars" -auto-approve 
	rm -rf files 
	rm -rf .terraform 
	rm -rf .terraform.lock.hcl 
	rm -rf .terraform && 
	rm -rf .terraform.lock.hcl && 
	rm -rf  terraform.tfstate && 
	rm -rf  terraform.tfstate.backup

### EKS Backend ###
delete-backend:
	$(MAKE) -C ./remote_backend delete-all

##### EKS Destroy-ALL #####
delete-all: eks-ingress-delete eks-delete

### Delete Both ###
delete-both: eks-ingress-delete eks-delete delete-backend

### Both ###
both: backend eks-init-plan eks-apply eks-ingress