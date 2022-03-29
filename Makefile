COMPOSE = docker-compose

DOCKER_EXEC = ${COMPOSE} exec
DOCKER_EXEC_PHP = ${DOCKER_EXEC} ${CTNR_PHP}
DOCKER_EXEC_NODE = ${DOCKER_EXEC} ${CTNR_NODE}
DOCKER_EXEC_PHP_BC = ${DOCKER_EXEC_PHP} ${PHP_BC}

CTNR_PHP = php_service
CTNR_NODE = nodejs_service

PHP_BC = php bin/console

.PHONY: start
# Build and run all containers
start: stop
	${COMPOSE} up -d --build
	${DOCKER_EXEC_PHP} composer install

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
