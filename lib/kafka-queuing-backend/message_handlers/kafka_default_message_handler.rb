# frozen_string_literal: true

require 'json'

class KafkaDefaultMessageHandler
  def initialize(options: {})
    @options = options
  end

  def handle(message)
    message_payload = JSON.parse(message.payload, symbolize_names: true)
    job             = message_payload.fetch(:job_class).constantize
    arguments       = message_payload.fetch(:arguments)
    job.perform_now(*arguments)
  end
end
