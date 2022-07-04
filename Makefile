.PHONY: site
site:
	@hugo

.PHONY: dev
dev:
	@hugo server --navigateToChanged

.PHONY: cache
cache:
	@./scripts/update-cache.sh

.PHONY: infra
infra:
	@terraform -chdir=droplet-config/terraform init
	@terraform -chdir=droplet-config/terraform apply
	@terraform -chdir=droplet-config/terraform output -raw droplet_ipv4_address > droplet-config/ansible/hosts.ini

.PHONY: preview
preview:
	@./scripts/preview-server.sh

.PHONY: server
server:
	@ANSIBLE_CONFIG=droplet-config/ansible/ansible.cfg ansible-playbook --inventory droplet-config/ansible/hosts.ini --private-key ./secrets/remote-user.pem droplet-config/ansible/main.yml --extra-vars @droplet-config/ansible/versions.yml

.PHONY: server-%
server-%:
	@ANSIBLE_CONFIG=droplet-config/ansible/ansible.cfg ansible-playbook --inventory droplet-config/ansible/hosts.ini --private-key ./secrets/remote-user.pem droplet-config/ansible/manage-$*.yml --extra-vars @droplet-config/ansible/versions.yml

.PHONY: ssh-%
ssh-%:
	@ssh -i ./secrets/remote-user.pem $*@`cat droplet-config/ansible/hosts.ini`

.PHONY: backup
backup:
	@ANSIBLE_CONFIG=droplet-config/ansible/ansible.cfg ansible-playbook --inventory droplet-config/ansible/hosts.ini --private-key ./secrets/remote-user.pem droplet-config/ansible/create-backup.yml --extra-vars "date='$$(date -u "+%Y-%m-%d %H:%M:%S")'"

.PHONY: backup-restore
backup-restore:
	@ANSIBLE_CONFIG=droplet-config/ansible/ansible.cfg ansible-playbook --inventory droplet-config/ansible/hosts.ini --private-key ./secrets/remote-user.pem droplet-config/ansible/restore-backup.yml
