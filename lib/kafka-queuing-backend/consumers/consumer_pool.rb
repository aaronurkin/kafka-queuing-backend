# frozen_string_literal: true

require 'concurrent'
require 'kafka-queuing-backend/consumer_factory'

module KafkaQueuingBackend
  class ConsumerPool
    class << self
      # Adds a consumer
      def add(consumer)
        raise ArgumentError, 'A consumer must be provided' if consumer.nil?

        consumer_name = consumer.fetch(:name)

        unless exists?(consumer_name)
          thread = Thread.new do
            Thread.current.name = consumer_name
            Thread.current.thread_variable_set(:started_at, Time.now)
            subscribe(consumer) unless exists?(consumer_name)
          rescue => error
            Rails.logger.error "FAILED subscribing '#{consumer_name}' consumer to '#{consumer.fetch(:topics)}' topics. \
            Error: #{error}\n#{error.backtrace.join("\n")}"
          end

          threads.store(consumer_name, thread.join)
        else
          puts "The '#{consumer_name}' consumer has already been added"
        end
      end

      # Stops the consumer
      def stop(consumer_name)
        return unless exists?(consumer_name)

        begin
          thread = threads.fetch(consumer_name)
        rescue => error
          puts "The '#{consumer_name}' consumer was not found. It's already stopped or hasn't been started. Error: #{error}\n#{error.backtrace.join("\n")}"
        else
          begin
            self.terminate(thread)
          rescue => error
            Rails.logger.error "FAILED stopping the '#{consumer_name}' consumer. Error: #{error}\n#{error.backtrace.join("\n")}"
          else
            threads.delete(consumer_name)
          end
        end
      end

      # Stops all the consumers
      def stop_all
        threads.keys.each { | consumer_name | self.stop(consumer_name) }
      end

      # How many consumers are added already
      def count
        threads.size
      end

      def threads
        if @threads.nil?
          @threads = Concurrent::Hash.new
        end
        @threads
      end

      private
        # Does consumer already added
        def exists?(consumer_name)
          threads.key?(consumer_name)
        end

        def terminate(thread)
          thread.join(0.1)
          thread.exit
          sleep(0.001) while thread.alive?
        end

        def subscribe(consumer)
          consumer_name     = consumer.fetch(:name)
          consumers_group   = consumer.fetch(:group)
          topics            = consumer.fetch(:topics)

          consumer_instance = KafkaQueuingBackend::ConsumerFactory.create(
            name: consumer_name,
            group: consumers_group
          )

          consumer_instance.subscribe(topics)
        ensure
          consumer_instance.stop unless consumer_instance.nil?
        end
    end
  end
end