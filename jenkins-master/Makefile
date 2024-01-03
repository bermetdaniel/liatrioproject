repo = jenkins-master
region = us-west-1
namespace = jenkins-master
version = 1.1
hostname = jenkins-master.bema-liatrio.com
hosted_zone = bema-liatrio.com
account = $(shell aws sts get-caller-identity --query "Account" --output text)
hosted_zone_id = $(shell aws route53 list-hosted-zones-by-name --dns-name "$(hosted_zone)" --query 'HostedZones[0].Id' --output text)
elb_hosted_zone_id = $(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].CanonicalHostedZoneId' --output text)
elb_url = $(shell aws elbv2 describe-load-balancers --query 'LoadBalancers[*].DNSName' --output text)

testing:
	@echo current image version is $(version)

build: testing
	docker build -t $(repo):$(version) . --no-cache

login: build
	aws ecr get-login-password --region $(region) | docker login --username AWS --password-stdin $(account).dkr.ecr.$(region).amazonaws.com

push: login
	docker tag $(repo):$(version) $(account).dkr.ecr.$(region).amazonaws.com/$(repo):$(version)
	docker push $(account).dkr.ecr.$(region).amazonaws.com/$(repo):$(version)

deploy: namespace configmap
	cat deployment.yaml | sed "s/ACCT_NUMBER/$(account)/g;s/IMAGE_VERSION/$(version)/g;s/CUSTOM_NAMESPACE/$(namespace)/g;s/REPO/$(repo)/g;s/HOSTNAME/$(hostname)/g" | kubectl -n $(namespace) apply -f -

namespace: 
	cat namespace.yaml | sed "s/CUSTOM_NAMESPACE/$(namespace)/g" | kubectl apply -f -

configmap: deletecm
	kubectl create configmap jenkins-casc-cm --from-file=./jenkins-casc.yaml -n $(namespace)

record:
	$(eval elb_hosted_zone_id := $(shell aws elbv2 describe-load-balancers --query 'LoadBalancers[?DNSName==`$(elb_url)`].CanonicalHostedZoneId' --output text))
	- aws route53 change-resource-record-sets \
  		--hosted-zone-id $(hosted_zone_id) \
  		--change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"$(hostname)","Type":"A","AliasTarget":{"HostedZoneId":"$(elb_hosted_zone_id)","DNSName":"$(elb_url)","EvaluateTargetHealth":true}}}]}'

test: deploy record
	sleep 100
	curl -v http://$(hostname)

all: push deploy record test


deletecm:
	- kubectl delete configmap jenkins-casc-cm -n $(namespace)

delete: deletecm
	- cat deployment.yaml | sed "s/ACCT_NUMBER/$(account)/g;s/IMAGE_VERSION/$(version)/g;s/CUSTOM_NAMESPACE/$(namespace)/g;s/REPO/$(repo)/g;s/HOSTNAME/$(hostname)/g" | kubectl -n $(namespace) delete -f -
	- kubectl delete configmap jenkins-casc-cm -n $(namespace)
	- cat namespace.yaml | sed "s/CUSTOM_NAMESPACE/$(namespace)/g" | kubectl delete -f -

delete-record:
	$(eval elb_hosted_zone_id := $(shell aws elbv2 describe-load-balancers --query 'LoadBalancers[?DNSName==`$(elb_url)`].CanonicalHostedZoneId' --output text))
	- aws route53 change-resource-record-sets \
		--hosted-zone-id $(hosted_zone_id) \
		--change-batch '{"Changes":[{"Action":"DELETE","ResourceRecordSet":{"Name":"$(hostname)","Type":"A","AliasTarget":{"HostedZoneId":"$(elb_hosted_zone_id)","DNSName":"$(elb_url)","EvaluateTargetHealth":true}}}]}'

delete-all: delete delete-record