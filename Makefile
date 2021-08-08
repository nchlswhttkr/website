.PHONY: backup backup-restore cache dev droplet preview server server-% ssh

site:
	hugo

cache:
	./scripts/update-cache.sh

dev:
	hugo server

droplet:
	terraform -chdir=droplet-config/terraform init -upgrade
	terraform -chdir=droplet-config/terraform apply
	terraform -chdir=droplet-config/terraform output --raw droplet_ipv4_address > droplet-config/ansible/hosts.ini

preview:
	./scripts/preview-server.sh

server:
	ANSIBLE_CONFIG=droplet-config/ansible/ansible.cfg ansible-playbook droplet-config/ansible/main.yml --inventory droplet-config/ansible/hosts.ini --extra-vars @droplet-config/ansible/versions.yml

server-%:
	ANSIBLE_CONFIG=droplet-config/ansible/ansible.cfg ansible-playbook droplet-config/ansible/manage-$*.yml --inventory droplet-config/ansible/hosts.ini --extra-vars @droplet-config/ansible/versions.yml

ssh:
	ssh nicholas@`cat droplet-config/ansible/hosts.ini`

backup:
	ANSIBLE_CONFIG=droplet-config/ansible/ansible.cfg ansible-playbook droplet-config/ansible/create-backup.yml --inventory droplet-config/ansible/hosts.ini --extra-vars "date='$$(date -u "+%Y-%m-%d %H:%M:%S")'"

backup-restore:
	ANSIBLE_CONFIG=droplet-config/ansible/ansible.cfg ansible-playbook droplet-config/ansible/restore-backup.yml --inventory droplet-config/ansible/hosts.ini
