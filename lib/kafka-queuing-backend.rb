# frozen_string_literal: true

require 'yaml'
require 'dotenv/load'
require 'kafka-queuing-backend/version'
require 'kafka-queuing-backend/producer_factory'

# == KafkaQueuingBackend
#
# Queuing Backend for Rails applications based on the Kafka event streaming platform.
module KafkaQueuingBackend
  raise "#{self.name} works inside a Rails applications only" unless defined?(Rails)

  class << self
    attr_writer :provider, :brokers, :consumers

    def configure
      yield self
    end

    def provider
      raise_missing_configuration_error(__method__) if @provider.nil?
      @provider
    end

    def brokers
      raise_missing_configuration_error(__method__) if @brokers.nil?
      @brokers
    end

    def consumers
      raise_missing_configuration_error(__method__) if @consumers.nil?
      @consumers
    end

    private
      def raise_missing_configuration_error(attribute)
        raise ArgumentError, "The 'attribute' argument is missing" if attribute.nil? || attribute.empty?
        raise MissingConfigurationError, attribute
      end
  end

  class MissingConfigurationError < StandardError
    def initialize(attribute)
      raise ArgumentError, "The 'attribute' argument is missing" if attribute.nil?
      super("The '#{attribute}' configuration is missing")
    end
  end
end
