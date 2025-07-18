NAME = inception

COMPOSE = docker-compose
ENV_FILE = srcs/.env

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
	docker system prune -af --volumes

re: fclean all

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps
