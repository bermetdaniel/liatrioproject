appname = liatrio
region = us-east-1
hosted_zone = bermet.com
stage = dev
account = $(shell aws sts get-caller-identity --query "Account" --output text)
include configs/$(stage)
hosted_zone_id = $(shell aws route53 list-hosted-zones-by-name --dns-name "$(hosted_zone)" --query 'HostedZones[0].Id' --output text)
elb_hosted_zone_id = $(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].CanonicalHostedZoneId' --output text)
elb_url = $(shell aws elbv2 describe-load-balancers --query 'LoadBalancers[*].DNSName' --output text)

build:
	docker build -t $(appname):$(version) . --no-cache

login: build
	aws ecr get-login-password --region $(region) | docker login --username AWS --password-stdin $(account).dkr.ecr.$(region).amazonaws.com

push: login
	docker tag $(appname):$(version) $(account).dkr.ecr.$(region).amazonaws.com/$(appname):$(version)
	docker push $(account).dkr.ecr.$(region).amazonaws.com/$(appname):$(version)


deploy: 
	helm upgrade --install $(appname) k8s-chart/ --namespace=$(namespace) --create-namespace \
		--set applicationName=$(appname) \
		--set replicaCount=$(replicas) \
		--set image.repository=$(account).dkr.ecr.us-east-1.amazonaws.com/$(appname) \
		--set image.tag=$(version) \
		--set port=5000 \
		--set svcport=5000 \
		--set url=$(hostname)

record:
	$(eval elb_hosted_zone_id := $(shell aws elbv2 describe-load-balancers --query 'LoadBalancers[?DNSName==`$(elb_url)`].CanonicalHostedZoneId' --output text))
	- aws route53 change-resource-record-sets \
  		--hosted-zone-id $(hosted_zone_id) \
  		--change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"$(hostname)","Type":"CNAME","AliasTarget":{"HostedZoneId":"$(elb_hosted_zone_id)","DNSName":"$(elb_url)","EvaluateTargetHealth":true}}}]}'

test: deploy record 
	sleep 100
	curl -v http://$(hostname)

# all: push deploy record test

all: push deploy 

delete:
	- helm delete $(appname) --namespace=$(namespace)

delete-record:
	$(eval elb_hosted_zone_id := $(shell aws elbv2 describe-load-balancers --query 'LoadBalancers[?DNSName==`$(elb_url)`].CanonicalHostedZoneId' --output text))
	- aws route53 change-resource-record-sets \
		--hosted-zone-id $(hosted_zone_id) \
		--change-batch '{"Changes":[{"Action":"DELETE","ResourceRecordSet":{"Name":"$(hostname)","Type":"A","AliasTarget":{"HostedZoneId":"$(elb_hosted_zone_id)","DNSName":"$(elb_url)","EvaluateTargetHealth":true}}}]}'

delete-all: delete delete-record
