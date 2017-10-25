IP:=$(shell terraform output ip)
CERT=private.pem
ssh:
	@ssh root@$(IP) -i $(CERT)

ip:
	@terraform output ip

start: 
	@terraform init
	@terraform plan
	@terraform apply
