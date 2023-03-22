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
