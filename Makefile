COMPOSE = docker-compose
SHELL = bash

DOCKER_EXEC = ${COMPOSE} exec
DOCKER_EXEC_PHP = ${DOCKER_EXEC} ${CTNR_PHP}
DOCKER_EXEC_PHP_BC = ${DOCKER_EXEC_PHP} ${PHP_BC}
DOCKER_EXEC_PHP_COMPOSER = ${DOCKER_EXEC_PHP} composer
DOCKER_EXEC_PHP_NPM = ${DOCKER_EXEC_PHP} npm
DOCKER_EXEC_NODE = ${DOCKER_EXEC} ${CTNR_NODE}
DOCKER_EXEC_NODE_NPM = ${DOCKER_EXEC_NODE} npm
DOCKER_EXEC_T_NODE_NPM = ${DOCKER_EXEC} -T ${CTNR_NODE} npm

CTNR_PHP = php_service
CTNR_NODE = nodejs_service

PHP_BC = php bin/console

.PHONY: start
# Build and run all containers
start: stop
	${COMPOSE} up -d --build
	make post_start

.PHONY: post_start
# Setup all deps in the containers
post_start: post_start_php post_start_node
	clear

.PHONY: post_start_node
# Setup all deps in nodejs_service
post_start_node:
	${DOCKER_EXEC_NODE_NPM} install
	${DOCKER_EXEC_T_NODE_NPM} run start &

.PHONY: post_start_php
# Setup all deps in php_service
post_start_php:
	${DOCKER_EXEC_PHP_COMPOSER} install
	${DOCKER_EXEC_PHP_NPM} install
	${DOCKER_EXEC_PHP_NPM} run dev
	make cache
	${DOCKER_EXEC_PHP_BC} d:m:m -q
	${DOCKER_EXEC_PHP_BC} d:f:l -q
	${DOCKER_EXEC_PHP_BC} a:u:c -qr ROLE_ADMIN admin@localhost.fr

.PHONY: php_sh
# Run shell inside php-container
php_sh:
	${DOCKER_EXEC_PHP} ${SHELL}

.PHONY: node_sh
# Run shell inside node-container
node_sh:
	${DOCKER_EXEC_NODE} ${SHELL}

.PHONY: stop
# Stop and remove all containers
stop:
	${COMPOSE} down --remove-orphans

.PHONY: debug
# Print containers state and logs
debug:
	${COMPOSE} ps
	${COMPOSE} logs

.PHONY: update
# Update dependencies in all containers
update: update_php update_node

.PHONY: update_php
# Update dependencies in php-container
update_php:
	${DOCKER_EXEC_PHP_COMPOSER} update
	${DOCKER_EXEC_PHP_NPM} update

.PHONY: update_node
# Update dependencies in node-container
update_node:
	${DOCKER_EXEC_NODE_NPM} update

.PHONY: migration
# Create migration in php-container
migration:
	${DOCKER_EXEC_PHP_BC} m:mi

.PHONY: cache
# Clear cache in php-container
cache:
	${DOCKER_EXEC_PHP_BC} doctrine:cache:clear-meta
	${DOCKER_EXEC_PHP_BC} doctrine:cache:clear-query
	${DOCKER_EXEC_PHP_BC} doctrine:cache:clear-result
	${DOCKER_EXEC_PHP_BC} c:c
