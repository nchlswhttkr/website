.PHONY: site
site:
	@hugo

.PHONY: dev
dev:
	@hugo server --navigateToChanged

.PHONY: cache
cache:
	@./scripts/update-cache.sh

.PHONY: preview
preview:
	@./scripts/preview-server.sh

.PHONY: infra
infra:
	@terraform -chdir=infrastructure init
	@terraform -chdir=infrastructure apply

.PHONY: deploy
deploy:
	@echo "" | gpg --clearsign > /dev/null
	@pip3 install --quiet --requirement .venv/requirements.txt
	@ansible-galaxy collection install --requirement .venv/ansible-requirements.yml
	@cd deploy && ansible-playbook --inventory hosts.yml deploy.yml --private-key ../secrets/remote-user.pem

.PHONY: backup
backup:
	@echo "" | gpg --clearsign > /dev/null
	@cd deploy && ansible-playbook --inventory hosts.yml backup.yml --private-key ../secrets/remote-user.pem --extra-vars "date='$$(date -u "+%Y-%m-%d %H:%M:%S")'"

.PHONY: restore
restore:
	@echo "" | gpg --clearsign > /dev/null
	@cd deploy && ansible-playbook --inventory hosts.yml restore.yml --private-key ../secrets/remote-user.pem

.PHONY: ssh
ssh:
	@ssh -i secrets/remote-user.pem nicholas@$(shell terraform -chdir=infrastructure output -raw web_server_ipv4_address)

# TODO: Assert virtual environment is active for Ansible-related targets
