KafkaQueuingBackend.configure do | config |
  config.provider   = :kafka
  config.brokers    = ENV.fetch("KAFKA_HOST")
  config.consumers  = [
    {
      name: 'first_consumer',
      group: 'first_consumers_group',
      topics: [
        'test_topic_1',
        'test_topic_2'
      ]
    },
    {
      name: 'second_consumer',
      group: 'second_consumers_group',
      topics: [
        'test_topic_3',
        'test_topic_4'
      ]
    },
    {
      name: 'third_consumer',
      group: 'first_consumers_group',
      topics: [
        'test_topic_5',
        'test_topic_2',
        'test_topic_3'
      ]
    }
  ]
end
