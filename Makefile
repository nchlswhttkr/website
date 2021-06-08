.PHONY: cache dev droplet preview server ssh

site:
	hugo

cache:
	./scripts/update-cache.sh

dev:
	hugo server

droplet:
	terraform -chdir=droplet-config/terraform init -upgrade
	terraform -chdir=droplet-config/terraform apply
	terraform -chdir=droplet-config/terraform output --raw droplet_ipv4_address |  tee droplet-config/ansible/hosts.ini

preview:
	./scripts/preview-server.sh

server: droplet
	ANSIBLE_CONFIG=droplet-config/ansible/ansible.cfg ansible-playbook droplet-config/ansible/manage-server.yml -i droplet-config/ansible/hosts.ini

ssh: droplet
	ssh nicholas@`cat droplet-config/ansible/hosts.ini`
