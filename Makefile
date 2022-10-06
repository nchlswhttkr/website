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
infra: check-doctl
	@terraform -chdir=infrastructure init
	@terraform -chdir=infrastructure apply

.PHONY: deploy
deploy: check-pass check-venv
	@pip3 install --quiet --requirement .venv/requirements.txt
	@ansible-galaxy collection install --requirement .venv/ansible-requirements.yml
	@cd deploy && ansible-playbook --inventory hosts.yml deploy.yml

.PHONY: backup
backup: check-pass check-venv
	@cd deploy && ansible-playbook --inventory hosts.yml backup.yml --extra-vars "date='$$(date -u "+%Y-%m-%d %H:%M:%S")'"

.PHONY: restore
restore: check-pass check-venv
	@cd deploy && ansible-playbook --inventory hosts.yml restore.yml

.PHONY: check-venv
check-venv:
	@./scripts/assert-venv-active.sh

.PHONY: check-pass
check-pass:
	@echo "" | gpg --clearsign >/dev/null

.PHONY: check-doctl
check-doctl:
	@doctl auth switch --context "nchlswhttkr"
