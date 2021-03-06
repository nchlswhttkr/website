.PHONY: backup backup-restore cache dev droplet preview server ssh

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

server:
	ANSIBLE_CONFIG=droplet-config/ansible/ansible.cfg ansible-playbook droplet-config/ansible/manage-server.yml --inventory droplet-config/ansible/hosts.ini --extra-vars @droplet-config/ansible/versions.yml

ssh: droplet
	ssh nicholas@`cat droplet-config/ansible/hosts.ini`

backup:
	./scripts/backup-server.sh

backup-restore:
	ANSIBLE_CONFIG=droplet-config/ansible/ansible.cfg ansible-playbook droplet-config/ansible/restore-backup.yml --inventory droplet-config/ansible/hosts.ini --extra-vars "date='$$(find backups -mindepth 1 -maxdepth 1 -type d | tail -n 1 | cut -d '/' -f 2)'"
