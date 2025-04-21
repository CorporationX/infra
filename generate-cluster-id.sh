#!/bin/bash

ENV_FILE=".env"

if grep -q KAFKA_KRAFT_CLUSTER_ID "$ENV_FILE"; then
  echo "KAFKA_KRAFT_CLUSTER_ID already exists in $ENV_FILE"
else
  echo "Generating KRaft Cluster ID..."
  CLUSTER_ID=$(uuidgen | base64 | tr -dc 'a-zA-Z0-9' | cut -c1-22)
  echo "KAFKA_KRAFT_CLUSTER_ID=$CLUSTER_ID" >> "$ENV_FILE"
  echo "Cluster ID $CLUSTER_ID saved to $ENV_FILE"
fi