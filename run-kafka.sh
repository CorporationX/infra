#!/bin/bash

set -e

if [[ "$1" == "--clean" ]]; then
  echo "🧨 Очистка данных Kafka..."
  rm -rf ./kafka-1-data ./kafka-2-data ./kafka-3-data
  rm -f .env
fi

bash generate-cluster-id.sh

docker-compose -f kafka-docker-compose.yaml -p kafka up -d