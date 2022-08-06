# frozen_string_literal: true

require 'kafka'

module KafkaQueuingBackend
  module TaskDefinition
    class Consumer
      class << self
        def consume(consumers)
          raise ArgumentError, "At least one consumer must be provided" if consumers.nil? || consumers.empty?

          consumers.select do | consumer_name |
            KafkaQueuingBackend.consumers.none? { | consumer | consumer_name == consumer[:name] }
          end.each do | consumer_name |
            puts "The '#{consumer_name}' consumer configuration was not found within the `config/initializers/kafka_queuing_backend.rb` file"
          end

          KafkaQueuingBackend.consumers.select { | consumer | consumers.include?(consumer[:name]) }.select do | consumer |
            belongs_to_group = consumer.key?(:group)
            puts "The #{:group} must be configured for the '#{consumer[:name]}' consumer configuration to receive messages" unless belongs_to_group
            belongs_to_group

          end.select do | consumer |
            missing_topics = consumer.fetch(:topics, []).empty?
            puts "At least one topic must be configured for the '#{consumer[:name]}' consumer configuration" if missing_topics
            !missing_topics

          end.each { | consumer | KafkaQueuingBackend::ConsumerPool.add(consumer) }
        end
      end
    end
  end
end
