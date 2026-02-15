#!/bin/bash
# Удобный wrapper для выполнения команд clawdbot в контейнере

set -e

# Цвета для вывода
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

if [ "$1" = "shell" ]; then
    echo -e "${BLUE}Вход в shell контейнера clawdbot...${NC}"
    docker exec -it clawdbot /bin/sh
elif [ "$1" = "logs" ]; then
    echo -e "${BLUE}Логи контейнера clawdbot...${NC}"
    docker compose logs -f clawdbot
elif [ "$1" = "status" ]; then
    echo -e "${BLUE}Статус контейнера clawdbot:${NC}"
    docker compose ps
    echo ""
    echo -e "${BLUE}Health status:${NC}"
    docker inspect --format='{{.State.Health.Status}}' clawdbot 2>/dev/null || echo "Health check недоступен"
elif [ "$1" = "help" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo -e "${GREEN}Использование: ./clawdbot.sh [команда|опция]${NC}"
    echo ""
    echo "Специальные команды:"
    echo "  shell      - Войти в shell контейнера"
    echo "  logs       - Показать логи контейнера"
    echo "  status     - Показать статус контейнера"
    echo "  help       - Показать эту справку"
    echo ""
    echo "Любая другая команда будет передана clawdbot внутри контейнера."
    echo ""
    echo "Примеры:"
    echo "  ./clawdbot.sh shell              # Войти в контейнер"
    echo "  ./clawdbot.sh --version          # Версия clawdbot"
    echo "  ./clawdbot.sh --help             # Справка clawdbot"
    echo "  ./clawdbot.sh onboard            # Запустить onboarding"
    echo "  ./clawdbot.sh doctor             # Запустить doctor"
    echo "  ./clawdbot.sh gateway            # Запустить gateway"
else
    # Передать все аргументы в clawdbot внутри контейнера
    if [ $# -eq 0 ]; then
        docker exec -it clawdbot clawdbot
    else
        docker exec -it clawdbot clawdbot "$@"
    fi
fi
