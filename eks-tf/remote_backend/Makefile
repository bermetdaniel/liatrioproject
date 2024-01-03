##### Backend #####

### Plan Backend ###
plan:
	terraform init && terraform plan -var-file="dev.tfvars"

### Create Backend ###
apply:
	terraform apply -var-file="dev.tfvars" -auto-approve

### Backend ALL ###
all: plan apply

### Update Backend ###
update:
	terraform apply -var-file="dev.tfvars" -auto-approve

### Destroy Backend And Resources ###
delete-all:
	terraform destroy -var-file="dev.tfvars" -auto-approve
	rm -rf files
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
	rm -f terraform.tfstate
	rm -f terraform.tfstate.backup
