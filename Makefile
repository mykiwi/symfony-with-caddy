SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


FIG		= DOCKER_BUILDKIT=1 COMPOSE_DOCKER_CLI_BUILD=1 docker-compose
PHP		= $(FIG) exec web
SYMFONY	= $(PHP) bin/console

build:
	cp .env.local.dist .env.local
	$(FIG) build

start:
	$(FIG) up -d

kill:
	$(FIG) kill
	$(FIG) rm -f

db: vendor/autoload.php
	$(SYMFONY) do:da:dr --force --if-exists
	$(SYMFONY) do:da:cr
	$(SYMFONY) do:mi:mi --no-interaction --allow-no-migration
	$(SYMFONY) do:fi:lo --no-interaction

vendor/autoload.php: composer.lock
	$(PHP) composer install
