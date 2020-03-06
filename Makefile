# Set Help, default goal and WATCHTOWER_BASE
include help.mk

# Name of the project and docker image
NAME  := mkdocs-material

# OCI Metadata
IMAGE_TITLE             := Mkdocs Material
IMAGE_DESC              := Mkdocs Material Theme
IMAGE_URL               := https://hub.docker.com/r/tprasadtp/mkdocs-material
IMAGE_SOURCE            := https://github.com/tprasadtp/mkdocs-material-docker
IMAGE_LICENSES          := MIT
IMAGE_DOCUMENTATION     := https://github.com/tprasadtp/mkdocs-material

# Relative to
DOCKER_CONTEXT_DIR := $(WATCHTOWER_BASE)
DOCKER_SQUASH      := 1

# Version
VERSION          := $(shell grep "^mkdocs-material" $(WATCHTOWER_BASE)/requirements.txt | cut -f3 -d '=' | cut -f1 -d ' ')
UPSTREAM_PRESENT := true
UPSTREAM_AUTHOR  := Martin Donath
UPSTREAM_URL     := https://github.com/squidfunk/mkdocs-material

include docker.mk

.EXPORT_ALL_VARIABLES:

CUSTOM_COMPILE_COMMAND=make requirements

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
