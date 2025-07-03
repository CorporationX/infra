package com.aleksid.kafka_config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
@ConfigurationProperties(prefix = "spring.kafka")
@Data
public class KafkaTopicProperties {
    private List<TopicConfig> topics;

    @Data
    public static class TopicConfig {
        String name;
        int partitions;
        int replicas;
    }
}
