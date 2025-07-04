package com.aleksid.kafka_config;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.kafka.config.TopicBuilder;
import org.springframework.kafka.core.KafkaAdmin;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@EnableConfigurationProperties(KafkaTopicProperties.class)
@RequiredArgsConstructor
public class KafkaTopicCreator {
    private final KafkaTopicProperties kafkaTopicProperties;
    private final KafkaAdmin kafkaAdmin;

    @PostConstruct
    public void createTopics() {
        List<NewTopic> topics = kafkaTopicProperties.getTopics().stream()
                .map(cfg -> {
                    return TopicBuilder.name(cfg.getName())
                            .partitions(cfg.partitions)
                            .replicas(cfg.replicas)
                            .build();
                }).toList();
        kafkaAdmin.createOrModifyTopics(topics.toArray(NewTopic[]::new));
        log.info("Topics were created: {}",
                topics.stream().map(NewTopic::name).toList()
        );
    }
}
