#!/bin/bash
echo "Ожидание запуска Kafka..."
sleep 15

create_topic_if_not_exists() {
    local topic_name=$1
    
    kafka-topics --bootstrap-server kafka:29092 --list | grep -w "^${topic_name}$" > /dev/null
    
    if [ $? -eq 0 ]; then
        echo "✓ Топик '$topic_name' уже существует"
    else
        echo "→ Создание топика '$topic_name'..."
        kafka-topics --bootstrap-server kafka:29092 \
            --create \
            --topic "$topic_name" \
            --partitions 1 \
            --replication-factor 1
    fi
}

echo "Инициализация топиков Kafka"

create_topic_if_not_exists "analytics.profile-view"

echo "Инициализация завершена!"
kafka-topics --bootstrap-server kafka:29092 --list
