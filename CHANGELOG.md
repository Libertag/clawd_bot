# Changelog

Все важные изменения в этом проекте будут документированы в этом файле.

## [Unreleased]

### Changed (2026-02-15)
- **BREAKING**: Контейнер теперь запускается от root пользователя вместо `clawdbot`
- Обновлены пути volumes в docker-compose.yml с `/home/clawdbot/` на `/root/`
- Обновлена документация для отражения изменений в безопасности

### Причина изменения
При запуске от непривилегированного пользователя `clawdbot` возникала ошибка прав доступа:
```
Error: EACCES: permission denied, mkdir '/home/clawdbot/.clawdbot/agents/main/agent'
```

Запуск от root решает эту проблему и позволяет clawdbot создавать все необходимые файлы и директории.

### Миграция
Если у вас уже были созданы volumes с предыдущей версией:
```bash
# Остановить контейнер
docker compose down

# Удалить старые volumes
docker volume rm clawd_bot_clawdbot_data clawd_bot_clawdbot_config

# Пересобрать образ и запустить
docker compose build --no-cache
docker compose up -d
```

## [1.0.1] - 2026-02-15

### Added
- Добавлен вспомогательный скрипт `clawdbot.sh` для упрощения работы с контейнером
- Добавлено подробное руководство `USAGE.md` с примерами использования
- Добавлены результаты тестирования в `TESTING.md`

### Fixed
- Исправлена установка clawdbot через npm вместо install.sh (Alpine Linux не поддерживается)
- Исправлено создание пользователя (использован системный пользователь)
- Удалено устаревшее поле `version` из docker-compose.yml

## [1.0.0] - 2026-02-15

### Added
- Первый релиз Docker контейнера для Clawdbot
- Dockerfile на основе node:22-alpine
- docker-compose.yml для удобного управления
- Полная документация в README.md
- Примеры конфигурации (.env.example)
- .dockerignore и .gitignore
- Health check для мониторинга состояния контейнера
- Персистентные volumes для данных и конфигурации

### Technical Details
- Базовый образ: node:22-alpine
- Clawdbot версия: 2026.1.24-3
- Установка через npm global
- Volumes для /root/clawd и /root/.clawdbot
- Health check каждые 30 секунд
- Автоматический перезапуск (unless-stopped)

---

Формат основан на [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
