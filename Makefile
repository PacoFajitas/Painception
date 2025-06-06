NAME = inception

DOCKER_COMPOSE = srcs/docker-compose.yml

MYDATA_DIR = /home/tfiguero/data
DB_DIR = $(MYDATA_DIR)/mariadb
WP_DIR = $(MYDATA_DIR)/wordpress

all: setup build

# In setup we set up all the necessary for our docker-compose to work
setup:
	@echo "Creating volume directories"
	@mkdir -p $(DB_DIR)
	@mkdir -p $(WP_DIR)
	@echo "Setting up /etc/hosts entry"
	@grep -q "tfiguero.42.fr" /etc/hosts || echo "127.0.0.1 tfiguero.42.fr" | sudo tee -a /etc/hosts

# The option -d in the docker-compose up is to build it in the background
build:
	@echo "Building images and starting containers"
	@cd srcs && docker-compose up -d --build

stop:
	@echo "Stopping containers"
	@cd srcs && docker-compose stop

start:
	@echo "Starting containers"
	@cd srcs && docker-compose start

down:
	@echo "Removing containers"
	@cd srcs && docker-compose down

clean: down
	@echo "Removing volumes and data network"
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true

fclean: clean
	@echo "Removing all Docker images"
	@docker rmi $$(docker images -qa) 2>/dev/null || true
	@rm -rf ../../data/mariadb/*
	@rm -rf ../../data/wordpress/*

re: fclean all

.PHONY: all setup build stop start down clean fclean re
