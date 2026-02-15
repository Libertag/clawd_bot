# Руководство по использованию Clawdbot в Docker

## Быстрый старт

### Проверка статуса контейнера

```bash
# Проверить, что контейнер запущен
docker compose ps

# Или использовать вспомогательный скрипт
./clawdbot.sh status
```

## Способы работы с Clawdbot

### Вариант 1: Использование вспомогательного скрипта (рекомендуется)

Я создал для вас удобный скрипт `clawdbot.sh`:

```bash
# Войти в shell контейнера
./clawdbot.sh shell

# Проверить версию
./clawdbot.sh --version

# Посмотреть справку
./clawdbot.sh --help

# Запустить onboarding (первоначальная настройка)
./clawdbot.sh onboard

# Запустить doctor (проверка системы)
./clawdbot.sh doctor

# Посмотреть логи
./clawdbot.sh logs

# Проверить статус
./clawdbot.sh status
```

### Вариант 2: Прямое использование docker exec

```bash
# Выполнить команду clawdbot
docker exec -it clawdbot clawdbot --version

# Войти в shell контейнера
docker exec -it clawdbot /bin/sh

# После входа в shell можете работать как обычно:
clawdbot --help
clawdbot onboard
clawdbot gateway
exit  # выйти из контейнера
```

### Вариант 3: Использование docker compose exec

```bash
# Выполнить команду
docker compose exec clawdbot clawdbot --version

# Войти в shell
docker compose exec clawdbot /bin/sh
```

## Основные команды Clawdbot

После входа в контейнер (или используя скрипт/docker exec):

### Первоначальная настройка

```bash
# Интерактивная настройка
clawdbot onboard

# Или пошагово:
clawdbot setup           # Инициализация
clawdbot configure       # Настройка credentials
```

### Управление Gateway

```bash
# Запустить Gateway
clawdbot gateway

# Проверить статус
clawdbot health

# Посмотреть логи
clawdbot logs
```

### Работа с каналами

```bash
# Статус каналов
clawdbot status

# Подключить WhatsApp
clawdbot channels login

# Список каналов
clawdbot channels list
```

### Отправка сообщений

```bash
# Отправить сообщение
clawdbot message send --target +1234567890 --message "Hello"

# С указанием канала
clawdbot message send --channel telegram --target @username --message "Hi"
```

### Агенты и автоматизация

```bash
# Запустить агента
clawdbot agent --to +1234567890 --message "Run summary"

# Управление агентами
clawdbot agents list
```

### Системные команды

```bash
# Проверка здоровья системы
clawdbot doctor

# Открыть dashboard
clawdbot dashboard

# Обновление плагинов
clawdbot plugins update --all

# Просмотр сессий
clawdbot sessions
```

## Практические примеры

### Пример 1: Вход и первоначальная настройка

```bash
# 1. Войти в контейнер
./clawdbot.sh shell

# 2. Запустить onboarding
clawdbot onboard

# 3. Следовать инструкциям на экране
# 4. После завершения выйти
exit
```

### Пример 2: Быстрая проверка версии

```bash
./clawdbot.sh --version
# Вывод: 2026.1.24-3
```

### Пример 3: Запуск Gateway в фоновом режиме

```bash
# В контейнере gateway уже может быть запущен
# Проверить статус:
./clawdbot.sh health

# Если нужно запустить:
docker compose exec -d clawdbot clawdbot gateway
```

### Пример 4: Просмотр логов в реальном времени

```bash
./clawdbot.sh logs
# Или
docker compose logs -f clawdbot
```

## Управление контейнером

### Запуск и остановка

```bash
# Запустить контейнер
docker compose up -d

# Остановить контейнер
docker compose down

# Перезапустить контейнер
docker compose restart

# Пересобрать образ
docker compose build
docker compose up -d
```

### Просмотр логов

```bash
# Все логи
docker compose logs clawdbot

# Последние N строк
docker compose logs --tail=50 clawdbot

# В реальном времени
docker compose logs -f clawdbot
```

### Информация о контейнере

```bash
# Статус
docker compose ps

# Детальная информация
docker inspect clawdbot

# Health check
docker inspect --format='{{.State.Health.Status}}' clawdbot

# Использование ресурсов
docker stats clawdbot
```

## Персистентность данных

Контейнер использует Docker volumes для сохранения данных:

```bash
# Посмотреть volumes
docker volume ls | grep clawd_bot

# Информация о volume
docker volume inspect clawd_bot_clawdbot_data
docker volume inspect clawd_bot_clawdbot_config
```

Данные сохраняются даже после перезапуска контейнера.

## Очистка

### Полная очистка с удалением данных

```bash
# Остановить и удалить контейнер вместе с volumes
docker compose down -v

# Удалить образ
docker rmi clawdbot:latest
```

### Частичная очистка

```bash
# Только остановить контейнер (данные сохранятся)
docker compose down

# Перезапустить с чистого листа (volumes останутся)
docker compose down
docker compose up -d
```

## Отладка

### Проблемы с запуском

```bash
# Проверить логи
docker compose logs clawdbot

# Проверить статус health check
docker inspect --format='{{.State.Health}}' clawdbot

# Войти в контейнер для диагностики
docker exec -it clawdbot /bin/sh
```

### Проблемы с командами

```bash
# Убедиться, что clawdbot установлен
docker exec clawdbot which clawdbot

# Проверить версию Node.js
docker exec clawdbot node --version

# Проверить переменные окружения
docker exec clawdbot env | grep CLAWDBOT
```

## Полезные советы

1. **Используйте скрипт `clawdbot.sh`** - он упрощает работу с контейнером

2. **Для интерактивных команд** всегда используйте флаг `-it`:
   ```bash
   docker exec -it clawdbot clawdbot onboard
   ```

3. **Логи** помогут понять, что происходит:
   ```bash
   ./clawdbot.sh logs
   ```

4. **Health check** покажет состояние:
   ```bash
   ./clawdbot.sh status
   ```

5. **Volumes сохраняют данные** - не бойтесь перезапускать контейнер

6. **Для продакшена** можете изменить CMD в Dockerfile на конкретную команду clawdbot

## Дополнительная информация

- Официальная документация: https://docs.molt.bot/
- GitHub репозиторий проекта: https://github.com/Libertag/clawd_bot
- Официальный сайт Clawdbot: https://molt.bot/

---

**Нужна помощь?** Откройте issue на GitHub или обратитесь к официальной документации Clawdbot.
