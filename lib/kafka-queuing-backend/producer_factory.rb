# frozen_string_literal: true

require 'kafka-queuing-backend/producers/kafka_producer'

module KafkaQueuingBackend
  class ProducerFactory
    class << self
      def create(name:, options: {})
        case KafkaQueuingBackend.provider
        when :kafka
          kafka_producer_options = {
            "bootstrap.servers": KafkaQueuingBackend.brokers,
            "max.in.flight": options.fetch(:max_in_flight, 1000000),
            "request.required.acks": options.fetch(:acknowledgements, -1),
            "compression.codec": options.fetch(:compression_codec, 'none'),
            "partitioner": options.fetch(:partitioner, 'consistent_random'),
            "message.max.bytes": options.fetch(:message_max_bytes, 1000000),
            "message.timeout.ms": options.fetch(:message_timeout_ms, 300000),
            "auto.offset.reset": options.fetch(:auto_offset_reset, 'largest'),
            "metadata.max.age.ms": options.fetch(:metadata_max_age_ms, 900000),
            "message.copy.max.bytes": options.fetch(:message_copy_max_bytes, 65535),
            "receive.message.max.bytes": options.fetch(:receive_message_max_bytes, 100000000),
            "topic.metadata.refresh.interval.ms": options.fetch(:topic_metadata_refresh_interval_ms, 300000),
            "max.in.flight.requests.per.connection": options.fetch(:max_in_flight_requests_per_connection, 1000000)
          }
          KafkaProducer.new(name: name, options: kafka_producer_options)
        else
          raise "Unknown provider: #{KafkaQueuingBackend.provider}"
        end
      end
    end
  end
end
