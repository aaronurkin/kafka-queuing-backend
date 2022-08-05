# frozen_string_literal: true

require 'kafka-queuing-backend/consumers/kafka_consumer'

module KafkaQueuingBackend
  class ConsumerFactory
    class << self
      def create(name:, group:, options: {})
        case KafkaQueuingBackend.provider
        when :kafka
          kafka_consumer_options = {

          }
          KafkaConsumer.new(name: name, group: group, options: kafka_consumer_options)
        else
          raise "Unknown provider: #{KafkaQueuingBackend.provider}"
        end
      end
    end
  end
end
