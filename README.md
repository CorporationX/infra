# infra

Инфраструктурная директория для локальной разработки (PostgreSQL, Redis, MinIO, Kafka).

## Запуск

```bash
./run.sh
```

**Kafka UI:** http://localhost:8989/

## Работа с Kafka топиками

**ВАЖНО:** Топики создаются **ТОЛЬКО** через конфигурационный файл. В коде через бины топики НЕ создаем!

### Как добавить новый топик:

1. Добавить топик в `kafka-topics.conf` (формат: `название:количество_партиций`):
   ```
   analytics.profile-view:3
   analytics.user-action:5
   ```

2. Перезапустить контейнер `init-kafka`:
   - Через Docker Desktop: перезапустить контейнер `init-kafka`
   - Через CLI: `docker-compose restart init-kafka`

3. Проверить создание топика в Kafka UI или через CLI:
   ```bash
   docker exec kafka kafka-topics --bootstrap-server localhost:9092 --list
   ```

**Если создали новый топик:** обязательно сообщите коллегам и закоммитьте изменения в `kafka-topics.conf`!
