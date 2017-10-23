IP:=$(shell terraform output ip)
CERT=private.pem
ssh:
	@ssh root@$(IP) -i $(CERT)
