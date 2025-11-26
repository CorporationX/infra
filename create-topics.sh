#!/bin/bash

KAFKA_CONTAINER="kafka"                    # имя контейнера
BOOTSTRAP="localhost:9092"                 # хост
TOPIC_FILE="./kafka-topics.txt"            # файл с топиками

# Путь к бинарникам именно в официальном образе apache/kafka
KAFKA_BIN="/opt/kafka/bin/kafka-topics.sh"

# Цвета
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Start creating topics for apache/kafka${NC}"

# Проверка контейнера
if ! docker ps --format '{{.Names}}' | grep -qw "$KAFKA_CONTAINER"; then
    echo -e "${RED}Container $KAFKA_CONTAINER not running!${NC}"
    exit 1
fi

# Проверка файла
[[ ! -f "$TOPIC_FILE" ]] && { echo -e "${RED}File $TOPIC_FILE not found!${NC}"; exit 1; }

while IFS= read -r line || [[ -n "$line" ]]; do
    # Чистим строку
    line=$(echo "$line" | sed 's/#.*//' | tr -d '\r' | xargs)
    [[ -z "$line" ]] && continue

    TOPIC=$(awk '{print $1}' <<< "$line")
    PART=$(awk '{print $2}' <<< "$line")

    # Если партиций не указано — ставим 3
    [[ -z "$PART" || ! "$PART" =~ ^[0-9]+$ ]] && PART=3

    echo -n "Topic '$TOPIC' ($PART partitions) — "

    # Проверяем существование топика
    if docker exec "$KAFKA_CONTAINER" "$KAFKA_BIN" --bootstrap-server "$BOOTSTRAP" --describe --topic "$TOPIC" >/dev/null 2>&1; then
        echo -e "${YELLOW}already exist${NC}"
    else
        echo -e "${GREEN}prepare${NC}"
        docker exec "$KAFKA_CONTAINER" "$KAFKA_BIN" \
            --bootstrap-server "$BOOTSTRAP" \
            --create \
            --topic "$TOPIC" \
            --partitions "$PART" \
            --replication-factor 1 \
            --config cleanup.policy=delete \
            --config retention.ms=604800000    # 7 дней хранение

        [ $? -eq 0 ] && echo -e "${GREEN}Topic '$TOPIC' successfully created${NC}" || echo -e "${RED}Error creating topic '$TOPIC'${NC}"
    fi

done < "$TOPIC_FILE"

echo -e "${GREEN}Ready! Current list of topics:${NC}"
docker exec "$KAFKA_CONTAINER" "$KAFKA_BIN" --bootstrap-server "$BOOTSTRAP" --list

echo -e "${GREEN}Done!${NC}"