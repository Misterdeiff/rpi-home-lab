# export MYUID := $(shell id -u)
# export MYGID := $(shell id -g)

DOCKER_COMPOSE_CMD=docker-compose -f docker-compose.yaml

.SILENT:
.DEFAULT_GOAL := help

ifeq ("$(wildcard .env)","")
	SETUP_ERROR = 1
	$(info please provide a valid .env file)
endif

ifdef SETUP_ERROR
	$(error Your setup has not been finished, please check information above / README.md)
endif

.PHONY: update
update: ## Update containers
	$(DOCKER_COMPOSE_CMD) pull

.PHONY: start
start:  ## Start the environment
	$(DOCKER_COMPOSE_CMD) up -d

.PHONY: stop
stop: ## Stop the environment
	$(DOCKER_COMPOSE_CMD) down --remove-orphans

.PHONY: reload
reload: ## Reload the environment
	$(DOCKER_COMPOSE_CMD) restart

.PHONY: restart
restart: stop start

.PHONY: samba
samba: ## Enter samba container
	$(DOCKER_COMPOSE_CMD) exec samba /bin/bash
	
.PHONY: plex
plex: ## Enter plex container
	$(DOCKER_COMPOSE_CMD) exec plex /bin/bash

.PHONY: transmission
transmission: ## Enter transmission container
	$(DOCKER_COMPOSE_CMD) exec transmission /bin/bash

.PHONY: flexget
flexget: ## Enter flexget container
	$(DOCKER_COMPOSE_CMD) exec flexget /bin/bash

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

# .PHONY: apply
# apply: ## Run an 'apply' in the given module. Requires 'env' and 'module' to be passed
# 	$(DOCKER_COMPOSE_CMD) exec tf-cli /bin/bash -c 'cd accounts/$(env)/$(module) && terragrunt apply'

# .PHONY: plan
# plan: ## Run a 'plan' in the given module. Requires 'env' and 'module' to be passed
# 	$(DOCKER_COMPOSE_CMD) exec tf-cli /bin/bash -c 'cd accounts/$(env)/$(module) && terragrunt plan'

# .PHONY: console
# console: ## Open a console inside terraform container
# 	$(DOCKER_COMPOSE_CMD) exec -w /app/accounts/ tf-cli bash -l