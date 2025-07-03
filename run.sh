docker-compose --project-name infra build
docker-compose --project-name infra up -d
docker-compose --project-name kafka-cluster -f kafka-compose.yml build
docker-compose --project-name kafka-cluster -f kafka-compose.yml up -d
