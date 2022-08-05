# frozen_string_literal: true

require 'kafka'
require 'securerandom'

class KafkaProducer
  attr_reader :id, :name

  def initialize(name:, options: {})
    @id       = SecureRandom.uuid
    @name     = name
    @options  = options
    @instance = Kafka::Producer.new(Kafka::Config.new(options))
  end

  def produce(topic:, payload:, timestamp: nil)
    # TODO: Handle and map the DeliveryReport
    @instance.produce(topic, payload, timestamp: timestamp)
  end
end
