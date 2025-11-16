#!/bin/bash
echo "Ожидание запуска Kafka..."
sleep 15

create_topic_if_not_exists() {
    local topic_name=$1
    local partitions=$2
    
    kafka-topics --bootstrap-server kafka:29092 --list | grep -w "^${topic_name}$" > /dev/null
    
    if [ $? -eq 0 ]; then
        echo "✓ Топик '$topic_name' уже существует"
    else
        echo "→ Создание топика '$topic_name' с $partitions партициями..."
        kafka-topics --bootstrap-server kafka:29092 \
            --create \
            --topic "$topic_name" \
            --partitions 3
    fi
}

echo "Инициализация топиков Kafka"

CONFIG_FILE="/scripts/kafka-topics.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Ошибка: файл конфигурации $CONFIG_FILE не найден"
    exit 1
fi

while IFS=: read -r topic_name partitions; do
    if [ -z "$topic_name" ] || [ -z "$partitions" ]; then
        continue
    fi
    create_topic_if_not_exists "$topic_name" "$partitions"
done < "$CONFIG_FILE"

echo "Инициализация завершена!"
kafka-topics --bootstrap-server kafka:29092 --list
