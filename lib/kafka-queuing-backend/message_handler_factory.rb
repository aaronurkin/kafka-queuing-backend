# frozen_string_literal: true

require 'kafka-queuing-backend/message_handlers/kafka_default_message_handler'

module KafkaQueuingBackend
  class MessageHandlerFactory
    class << self
      def create(options: {})
        case KafkaQueuingBackend.provider
        when :kafka
          if @kafka_default_message_handler.nil?
            # TODO: Map factory options to the KafkaMessageHandler options
            kafka_default_message_handler_options = {}
            @kafka_default_message_handler = KafkaDefaultMessageHandler.new(options: kafka_default_message_handler_options)
          end
          @kafka_default_message_handler
        else
          raise "Unknown provider: #{KafkaQueuingBackend.provider}"
        end
      end
    end
  end
end
