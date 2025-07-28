NAME = inception

COMPOSE = docker-compose
ENV_FILE = srcs/.env
IMAGES := $(shell docker images -q)

# Containers
CONTAINERS = mariadb wordpress nginx


.PHONY: all build up down clean fclean re logs

all: up

build:
	$(COMPOSE) -f ./srcs/docker-compose.yml --env-file $(ENV_FILE) build

up:
	$(COMPOSE) -f ./srcs/docker-compose.yml --env-file $(ENV_FILE) up -d

down:
	$(COMPOSE) -f ./srcs/docker-compose.yml down

clean: down
	docker rmi $(shell docker images -q --filter=reference="$(NAME)_*") 2>/dev/null || true

fclean: clean
	docker volume rm srcs_mariadb_data
	docker volume rm srcs_wordpress
	if [ -n "$(IMAGES)" ]; then docker rmi -f $(IMAGES); fi

re: fclean all

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps
