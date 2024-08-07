all: build up

# Path needs to be changed in school, this is my own computer's path

build:
		mkdir -p /home/migas/data/mariadb
		mkdir -p /home/migas/data/wordpress
		docker-compose -f ./srcs/docker-compose.yml build

up:
		docker-compose -f ./srcs/docker-compose.yml up

down:
		docker-compose -f ./srcs/docker-compose.yml down -v

# Here we use the logical operator OR to prevent stopping the process if there are any errors (no images to remove, etc)
# Docker system prune -af basically removes ALL unused data from docker
# !!Remember to remove sudo and fix path in school!!

clean: down

		sudo rm -rf /home/migas/data/mariadb
		sudo rm -rf /home/migas/data/wordpress
		@docker images -q > /dev/null 2>&1 && docker rmi -f $(docker images -qa) || true
		@docker network ls -q > /dev/null 2>&1 && docker network rm $(docker network ls -q) || true
		@docker volume ls -q > /dev/null 2>&1 && docker volume rm $(docker volume ls -q) || true
		docker system prune -af

re: clean build up