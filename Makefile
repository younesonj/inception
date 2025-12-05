# Variables
COMPOSE_FILE = srcs/docker-compose.yml
DATA_PATH = /home/younajja/data
MARIADB_DATA = $(DATA_PATH)/mariadb-data
WORDPRESS_DATA = $(DATA_PATH)/wordpress-data

# Colors
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[0;33m
NC = \033[0m

.PHONY: all up down clean fclean re logs ps stop restart

all: up

up:
	@echo "$(GREEN)Creating data directories and starting containers...$(NC)"
	@mkdir -p $(MARIADB_DATA) $(WORDPRESS_DATA)
	@docker compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN)Inception is running!$(NC)"

down:
	@echo "$(YELLOW)Stopping containers...$(NC)"
	@docker compose -f $(COMPOSE_FILE) down

stop:
	@echo "$(YELLOW)Stopping containers...$(NC)"
	@docker compose -f $(COMPOSE_FILE) stop

restart:
	@echo "$(YELLOW)Restarting containers...$(NC)"
	@docker compose -f $(COMPOSE_FILE) restart

clean: down
	@echo "$(RED)Removing containers, networks, and volumes...$(NC)"
	@docker compose -f $(COMPOSE_FILE) down -v
	@docker system prune -af

fclean: clean
	@echo "$(RED)Removing all data...$(NC)"
	@sudo rm -rf $(MARIADB_DATA)
	@sudo rm -rf $(WORDPRESS_DATA)
	@docker system prune -af --volumes
	@echo "$(RED)Full clean complete!$(NC)"

re: fclean all

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

ps:
	@docker compose -f $(COMPOSE_FILE) ps