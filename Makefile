.PHONY: *

export VAULT_TOKEN ?= $(shell pass show vault/root-token)
export HUGO_VIMEO_API_KEY ?= $(shell VAULT_TOKEN='$(VAULT_TOKEN)' vault kv get -field vimeo_api_key buildkite/website)
export HUGO_YOUTUBE_API_KEY ?= $(shell VAULT_TOKEN='$(VAULT_TOKEN)' vault kv get -field youtube_api_key buildkite/website)

site:
	@hugo --cleanDestinationDir --gc --minify

dev:
	@hugo server --navigateToChanged

preview:
	@./scripts/preview-server.sh
