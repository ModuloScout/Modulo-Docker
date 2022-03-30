COMPOSE = docker-compose

DOCKER_EXEC = ${COMPOSE} exec
DOCKER_EXEC_PHP = ${DOCKER_EXEC} ${CTNR_PHP}
DOCKER_EXEC_PHP_BC = ${DOCKER_EXEC_PHP} ${PHP_BC}
DOCKER_EXEC_NODE = ${DOCKER_EXEC} ${CTNR_NODE}
DOCKER_EXEC_NODE_NPM = ${DOCKER_EXEC} ${CTNR_NODE} npm

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

.PHONY: post_start_node
# Setup all deps in nodejs_service
post_start_node:
	${DOCKER_EXEC_NODE_NPM} install
	${DOCKER_EXEC_NODE_NPM} run start

.PHONY: post_start_php
# Setup all deps in php_service
post_start_php:
	${DOCKER_EXEC_PHP} composer install
	${DOCKER_EXEC_PHP} npm install
	${DOCKER_EXEC_PHP} npm run dev
	${DOCKER_EXEC_PHP_BC} doctrine:cache:clear-meta
	${DOCKER_EXEC_PHP_BC} doctrine:cache:clear-query
	${DOCKER_EXEC_PHP_BC} doctrine:cache:clear-result
	${DOCKER_EXEC_PHP_BC} d:m:m
	${DOCKER_EXEC_PHP_BC} d:f:l

.PHONY: php_sh
# Run shell inside php-container
php_sh:
	${DOCKER_EXEC_PHP} bash

.PHONY: node_sh
# Run shell inside node-container
node_sh:
	${DOCKER_EXEC_NODE} bash

.PHONY: stop
# Stop and remove all containers
stop:
	${COMPOSE} down --remove-orphans

.PHONY: debug
# Print containers state and logs
debug:
	${COMPOSE} ps
	${COMPOSE} logs
