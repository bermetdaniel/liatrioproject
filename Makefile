backend:
	$(MAKE) -C ./eks-tf/remote_backend all

eks:
	$(MAKE) -C ./eks-tf/module all

jenkins:
	$(MAKE) -C ./jenkins-master all

application:
	$(MAKE) -C ./app all

test-app:
	$(MAKE) -C ./app test

delete-app:
	$(MAKE) -C ./app delete-all

delete-jenkins:
	-$(MAKE) -C ./jenkins-master delete-all

delete-eks:
	$(MAKE) -C ./eks-tf/module delete-all

delete-backend:
	$(MAKE) -C ./eks-tf/remote_backend delete-all

all: backend eks jenkins application

test: backend eks application

delete-all: delete-app delete-jenkins delete-eks delete-backend
