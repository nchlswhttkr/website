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
deploy: pass venv
	@pip3 install --quiet --requirement .venv/requirements.txt
	@ansible-galaxy collection install --requirement .venv/ansible-requirements.yml
	@cd deploy && ansible-playbook --inventory hosts.yml deploy.yml --private-key ../secrets/remote-user.pem

.PHONY: backup
backup: pass venv
	@cd deploy && ansible-playbook --inventory hosts.yml backup.yml --private-key ../secrets/remote-user.pem --extra-vars "date='$$(date -u "+%Y-%m-%d %H:%M:%S")'"

.PHONY: restore
restore: pass venv
	@cd deploy && ansible-playbook --inventory hosts.yml restore.yml --private-key ../secrets/remote-user.pem

.PHONY: ssh
ssh:
	@ssh -i secrets/remote-user.pem nicholas@$(shell terraform -chdir=infrastructure output -raw web_server_ipv4_address)

.PHONY: venv
venv:
	@./scripts/assert-venv-active.sh

.PHONY: pass
pass:
	@echo "" | gpg --clearsign >/dev/null
