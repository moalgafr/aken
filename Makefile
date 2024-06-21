DOCKER_COMPOSE:= docker-compose -f ./srcs/docker-compose.yml
KEY_FOLDER:=/home/moalgafr/project/srcs/requirements/nginx/tools
all: up

cert_generate:
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout $(KEY_FOLDER)/moalgafri.key \
	-out $(KEY_FOLDER)/moalgafri.crt \
    -subj "/C=US/ST=State/L=AbuDhabi/O=42/CN=localhost"

up: cert_generate
	mkdir -p ~/data/mariadb ~/data/wordpress;
	$(DOCKER_COMPOSE) up -d --build

down:
	$(DOCKER_COMPOSE) down
	rm -rf $(KEY_FOLDER)/*

restart: down up


clean: down
	yes | docker system prune -a

fclean: clean
	sudo rm -rf ~/data/mariadb ~/data/wordpress

re: fclean up
# docker stop $(docker ps -qa)
# docker system prune --all --force --volumes
# docker network prune --force
# docker volume prune --force

