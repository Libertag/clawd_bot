# Clawdbot Docker Container

Docker-контейнер для запуска [Clawdbot](https://molt.bot/) (Moltbot) - мощного AI-ассистента для терминала.

## Описание

Этот проект предоставляет готовую Docker-конфигурацию для запуска Clawdbot в контейнере. Контейнер основан на `node:22-alpine` и включает все необходимые зависимости для работы бота.

## Особенности

- Легковесный образ на основе Alpine Linux
- Автоматическая установка Clawdbot через официальный install.sh
- Поддержка персистентности данных через Docker volumes
- Настройка через переменные окружения
- Безопасный запуск от непривилегированного пользователя
- Health checks для мониторинга состояния
- Готовый docker-compose.yml для быстрого старта

## Требования

- Docker 20.10+
- Docker Compose 2.0+ (опционально)
- 512MB RAM минимум (рекомендуется 2GB)

## Быстрый старт

### Использование Docker Compose (рекомендуется)

1. Клонируйте репозиторий:
```bash
git clone https://github.com/libertag/clawd_bot.git
cd clawd_bot
```

2. Создайте файл `.env` из примера:
```bash
cp .env.example .env
```

3. Отредактируйте `.env` и добавьте необходимые переменные окружения (API ключи и т.д.)

4. Запустите контейнер:
```bash
docker-compose up -d
```

5. Проверьте логи:
```bash
docker-compose logs -f clawdbot
```

### Использование Docker напрямую

1. Соберите образ:
```bash
docker build -t clawdbot:latest .
```

2. Запустите контейнер:
```bash
docker run -d \
  --name clawdbot \
  --restart unless-stopped \
  -v clawdbot_data:/home/clawdbot/clawd \
  -v clawdbot_config:/home/clawdbot/.clawdbot \
  --env-file .env \
  clawdbot:latest
```

3. Проверьте статус:
```bash
docker logs clawdbot
```

## Конфигурация

### Переменные окружения

Основные переменные окружения настраиваются в файле `.env`:

```bash
# Профиль Clawdbot
CLAWDBOT_PROFILE=default

# Окружение Node.js
NODE_ENV=production

# API ключи (если требуются)
ANTHROPIC_API_KEY=your_api_key_here
OPENAI_API_KEY=your_openai_key_here

# Дополнительные настройки
LOG_LEVEL=info
```

Полный список доступных переменных смотрите в файле `.env.example`.

### Volumes

Контейнер использует два volume для сохранения данных:

- `clawdbot_data` - рабочая директория бота (`/home/clawdbot/clawd`)
- `clawdbot_config` - конфигурационные файлы (`/home/clawdbot/.clawdbot`)

### Порты

По умолчанию контейнер не открывает никаких портов. Если ваш бот требует сетевого доступа, раскомментируйте секцию `ports` в `docker-compose.yml`:

```yaml
ports:
  - "8080:8080"
```

## Управление контейнером

### Docker Compose команды

```bash
# Запустить контейнер
docker-compose up -d

# Остановить контейнер
docker-compose down

# Перезапустить контейнер
docker-compose restart

# Просмотр логов
docker-compose logs -f

# Проверка статуса
docker-compose ps

# Обновление образа
docker-compose pull
docker-compose up -d --build
```

### Docker команды

```bash
# Запустить контейнер
docker start clawdbot

# Остановить контейнер
docker stop clawdbot

# Перезапустить контейнер
docker restart clawdbot

# Просмотр логов
docker logs -f clawdbot

# Выполнить команду внутри контейнера
docker exec -it clawdbot /bin/bash

# Проверить версию Clawdbot
docker exec clawdbot clawdbot --version
```

## Обновление

### Обновление Clawdbot

Чтобы обновить Clawdbot до последней версии:

```bash
# Остановите контейнер
docker-compose down

# Пересоберите образ
docker-compose build --no-cache

# Запустите контейнер
docker-compose up -d
```

### Обновление Docker образа

```bash
# Получите последние изменения из репозитория
git pull

# Пересоберите образ
docker-compose up -d --build
```

## Troubleshooting

### Контейнер не запускается

Проверьте логи:
```bash
docker-compose logs clawdbot
```

### Проблемы с правами доступа

Контейнер запускается от пользователя `clawdbot` (UID 1000). Если у вас проблемы с volumes, проверьте права:

```bash
docker-compose down
docker volume rm clawd_bot_clawdbot_data clawd_bot_clawdbot_config
docker-compose up -d
```

### Проверка health check

```bash
docker inspect --format='{{.State.Health.Status}}' clawdbot
```

### Доступ к shell контейнера

```bash
docker exec -it clawdbot /bin/sh
```

## Разработка

### Локальная сборка

```bash
# Сборка образа
docker build -t clawdbot:dev .

# Запуск с локальными изменениями
docker run -it --rm \
  -v $(pwd):/app \
  clawdbot:dev /bin/sh
```

### Отладка

Для отладки можно запустить контейнер в интерактивном режиме:

```bash
docker run -it --rm \
  --env-file .env \
  clawdbot:latest /bin/sh
```

## Структура проекта

```
.
├── Dockerfile              # Определение Docker образа
├── docker-compose.yml      # Конфигурация Docker Compose
├── install.sh              # Скрипт установки Clawdbot
├── .env.example            # Пример переменных окружения
├── .gitignore              # Игнорируемые файлы Git
├── .dockerignore           # Игнорируемые файлы Docker
└── README.md               # Документация
```

## Безопасность

- Контейнер работает от root для избежания проблем с правами доступа к файлам clawdbot
- Используется минимальный базовый образ Alpine Linux
- Все секреты передаются через переменные окружения
- Файл `.env` добавлен в `.gitignore` для предотвращения утечки секретов
- Для production окружения рекомендуется настроить запуск от непривилегированного пользователя

## Лицензия

Этот проект распространяется под лицензией MIT. Clawdbot имеет свою собственную лицензию.

## Ссылки

- [Официальный сайт Moltbot](https://molt.bot/)
- [Документация Moltbot](https://docs.molt.bot/)
- [GitHub репозиторий](https://github.com/libertag/clawd_bot)

## Поддержка

Если у вас возникли вопросы или проблемы:

1. Проверьте раздел [Troubleshooting](#troubleshooting)
2. Откройте Issue в GitHub репозитории
3. Обратитесь к официальной документации Clawdbot

## Changelog

### Version 1.0.0 (2026-02-15)
- Первый релиз
- Базовая Docker конфигурация
- Docker Compose поддержка
- Документация
