# Set the shell
SHELL := /bin/bash
REPO := mkdocs-material-docker
NAME := mkdocs-material

# Base of operations
ROOT_DIR := $(strip $(patsubst %/, %, $(dir $(realpath $(firstword $(MAKEFILE_LIST))))))
VERSION := $(shell grep "^mkdocs-material" $(ROOT_DIR)/requirements.txt | cut -f3 -d '=' | cut -f1 -d ' ')

.EXPORT_ALL_VARIABLES:

CUSTOM_COMPILE_COMMAND=make requirements

# Default Goal
.DEFAULT_GOAL := help

ifeq ($(GITHUB_ACTIONS),true)
	BRANCH := $(shell echo "$$GITHUB_REF" | cut -d '/' -f 3- | sed -r 's/[\/\*\#]+/-/g' )
else
	BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
	GITHUB_SHA := $(shell git rev-parse HEAD)
endif

# Version

# Enable Buidkit if not disabled
DOCKER_BUILDKIT ?= 1
BUILDX_ENABLE_PUSH ?= false

DOCKER_USER := tprasadtp

# Prefix for github package registry images
DOCKER_PREFIX_GITHUB := docker.pkg.github.com/$(DOCKER_USER)/$(REPO)

.PHONY: lint
lint: docker-lint ## Lint Everything


.PHONY: docker-lint
docker-lint: ## Lint Dockerfiles
	@echo -e "\033[92m➜ $@ \033[0m"
	docker run --rm -i hadolint/hadolint < $(ROOT_DIR)/Dockerfile

.PHONY: docker-cross
docker-cross: ## Cross Build
	@echo -e "\033[92m➜ $@ \033[0m"
	@echo -e "\033[92m✱ Building Docker Image [CROSS]\033[0m"
	@if [ $(BUILDX_ENABLE_PUSH) == "true" ]; then \
		bash $(ROOT_DIR)/build/buildx.sh --push; \
	else \
		bash $(ROOT_DIR)/build/buildx.sh; \
	fi

.PHONY: docker
docker: ## Build DockerHub image (runs as root inide docker)
	@echo -e "\033[92m➜ $@ \033[0m"
	@echo -e "\033[92m✱ Building Docker Image\033[0m"
	@DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) docker build --target base \
		-t $(NAME) \
		--build-arg GITHUB_ACTOR=$(GITHUB_ACTOR)\
		--build-arg GITHUB_SHA=$(GITHUB_SHA) \
		--build-arg GITHUB_WORKFLOW=$(GITHUB_WORKFLOW) \
		--build-arg GITHUB_RUN_NUMBER=$(GITHUB_RUN_NUMBER) \
		--build-arg VERSION=$(VERSION) \
		-f $(ROOT_DIR)/Dockerfile \
		$(ROOT_DIR)/
	@DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) docker build --target user \
		-t $(NAME)-user \
		--build-arg GITHUB_ACTOR=$(GITHUB_ACTOR)\
		--build-arg GITHUB_SHA=$(GITHUB_SHA) \
		--build-arg GITHUB_WORKFLOW=$(GITHUB_WORKFLOW) \
		--build-arg GITHUB_RUN_NUMBER=$(GITHUB_RUN_NUMBER) \
		--build-arg VERSION=$(VERSION) \
		-f $(ROOT_DIR)/Dockerfile \
		$(ROOT_DIR)/
	@if [ $(BRANCH) == "master" ]; then \
		echo -e "\033[92m✱ Tagging as latest \033[0m"; \
		docker tag $(NAME) $(DOCKER_USER)/$(NAME):latest; \
		docker tag $(NAME) $(DOCKER_PREFIX_GITHUB)/$(NAME):latest; \
		echo -e "\033[92m✱ Tagging as latest-user \033[0m"; \
		docker tag $(NAME)-user $(DOCKER_USER)/$(NAME):latest-user; \
		docker tag $(NAME)-user $(DOCKER_PREFIX_GITHUB)/$(NAME):latest-user; \
		echo -e "\033[92m✱ Tagging as $(VERSION)\033[0m"; \
		docker tag $(NAME) $(DOCKER_USER)/$(NAME):$(VERSION); \
		docker tag $(NAME) $(DOCKER_PREFIX_GITHUB)/$(NAME):$(VERSION); \
		echo -e "\033[92m✱ Tagging as $(VERSION)-user\033[0m"; \
		docker tag $(NAME)-user $(DOCKER_USER)/$(NAME):$(VERSION)-user; \
		docker tag $(NAME)-user $(DOCKER_PREFIX_GITHUB)/$(NAME):$(VERSION)-user; \
	else \
		echo -e "\033[92m✱ Tagging as $(BRANCH)\033[0m"; \
		docker tag $(NAME) $(DOCKER_USER)/$(NAME):$(BRANCH); \
		docker tag $(NAME) $(DOCKER_PREFIX_GITHUB)/$(NAME):$(BRANCH); \
		echo -e "\033[92m✱ Tagging as $(BRANCH)-user\033[0m"; \
		docker tag $(NAME)-user $(DOCKER_USER)/$(NAME):$(BRANCH)-user; \
		docker tag $(NAME)-user $(DOCKER_PREFIX_GITHUB)/$(NAME):$(BRANCH)-user; \
	fi

.PHONY: docker-push
docker-push: ## Push docker images (action and user images)
	@echo -e "\033[92m➜ $@ \033[0m"
	@if [ $(BRANCH) == "master" ]; then \
		echo -e "\033[92m✱ Pushing Tag: latest [DockerHub]\033[0m"; \
		# docker push $(DOCKER_USER)/$(NAME):latest; \
		# docker push $(DOCKER_USER)/$(NAME):latest-user; \
		echo -e "\033[92m✱ Pushing Tag: $(VERSION) [DockerHub]\033[0m"; \
		# docker push $(DOCKER_USER)/$(NAME):$(VERSION); \
		# docker push $(DOCKER_USER)/$(NAME):$(VERSION)-user; \
		echo -e "\033[92m✱ Pushing Tag: latest [GitHub]\033[0m"; \
		# docker push $(DOCKER_PREFIX_GITHUB)/$(NAME):latest; \
		# docker push $(DOCKER_PREFIX_GITHUB)/$(NAME):latest-user; \
		echo -e "\033[92m✱ Pushing Tag: $(VERSION) [GitHub] \033[0m"; \
		# docker push $(DOCKER_PREFIX_GITHUB)/$(NAME):$(VERSION); \
		# docker push $(DOCKER_PREFIX_GITHUB)/$(NAME):$(VERSION)-user; \
	else \
		echo -e "\033[92m✱ Pushing Tag: $(BRANCH)[DockerHub].\033[0m"; \
		# docker push $(DOCKER_USER)/$(NAME):$(BRANCH); \
		# docker push $(DOCKER_USER)/$(NAME):$(BRANCH)-user; \
		echo -e "\033[92m✱ Pushing Tag: $(BRANCH)[GitHub] \033[0m"; \
		# docker push $(DOCKER_PREFIX_GITHUB)/$(NAME):$(BRANCH); \
		# docker push $(DOCKER_PREFIX_GITHUB)/$(NAME):$(BRANCH)-user; \
	fi

.PHONY: help
help: ## This help dialog.
	@IFS=$$'\n' ; \
    help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
	printf "%-32s %s\n" " Target " "    Help " ; \
    printf "%-32s %s\n" "--------" "------------" ; \
    for help_line in $${help_lines[@]}; do \
        IFS=$$':' ; \
        help_split=($$help_line) ; \
        help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        printf '\033[92m'; \
        printf "➜ %-30s %s" $$help_command ; \
        printf '\033[0m'; \
        printf "%s\n" $$help_info; \
    done

# Python Stuff
.PHONY: requirements
requirements: ## Generate requirements.txt
	@echo -e "\033[1;92m➜ $@ \033[0m"
	@echo -e "\033[1;34m📄 Generating requirements file...\033[0m"
	@pip-compile -q

.PHONY: requirements-upgrade
requirements-upgrade: ## Upgrade requirements.txt
	@echo -e "\033[1;92m➜ $@ \033[0m"
	@echo -e "\033[1;34m📄 Upgrading requirements file...\033[0m"
	@pip-compile -U -q

.PHONY: debug-vars
debug-vars:
	@echo "GITHUB_ACTIONS: ${GITHUB_ACTIONS}"
	@echo "VERSION: ${VERSION}"
	@echo "BRANCH: ${BRANCH}"
	@echo "GITHUB_SHA: ${GITHUB_SHA}"
	@echo "GITHUB_WORKFLOW: ${GITHUB_WORKFLOW}"
	@echo "GITHUB_RUN_NUMBER: ${GITHUB_RUN_NUMBER}"
	@echo "GITHUB_ACTOR: ${GITHUB_ACTOR}"
