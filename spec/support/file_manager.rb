# frozen_string_literal: true

require 'fileutils'

module FileManager
  def add_initializer
    content = <<~RUBY
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
    RUBY
    File.open(initializer_file, 'w+:UTF-8') { |f| f.write content } unless initializer_file.nil?
  end

  def initializer_file
    "#{Rails.root}/config/initializers/kafka_queuing_backend.rb" if defined?(Rails)
  end

  def remove_initializer
    FileUtils.remove_file initializer_file if File.file?(initializer_file)
  end
end
