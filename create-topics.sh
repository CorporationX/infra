#!/bin/bash

CONFIG_FILE="topics.conf"
BROKER="kafka:9092"
PARTITIONS=1
REPLICATION_FACTOR=1

echo "Ожидаем доступность брокера Kafka ($BROKER)..."
until kafka-topics.sh --bootstrap-server "$BROKER" --list >/dev/null 2>&1; do
  sleep 2
done

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Файл $CONFIG_FILE не найден!"
  exit 1
fi

while IFS= read -r TOPIC || [[ -n "$TOPIC" ]]; do
  TOPIC=$(echo "$TOPIC" | tr -d '\r' | xargs)
  if [[ -z "$TOPIC" ]]; then continue; fi

  echo "Создаём топик: $TOPIC"
  kafka-topics.sh --bootstrap-server "$BROKER" \
                  --create \
                  --if-not-exists \
                  --topic "$TOPIC" \
                  --partitions "$PARTITIONS" \
                  --replication-factor "$REPLICATION_FACTOR"
done < "$CONFIG_FILE"
