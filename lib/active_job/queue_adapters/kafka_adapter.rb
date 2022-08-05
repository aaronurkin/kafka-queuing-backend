# frozen_string_literal: true

require "kafka"
require "securerandom"

module ActiveJob
  module QueueAdapters
    # == Active Job Kafka adapter
    #
    # The Kafka adapter runs jobs with the Kafka event streaming platform.
    #
    # This is a custom queue adapter. It needs a Kafka server
    # configured and running.
    #
    # To use this adapter, set queue adapter to +:kafka+:
    #
    #   config.active_job.queue_adapter = :kafka
    #
    # Or use the alias +:kqb+:
    #
    #   config.active_job.queue_adapter = :kqb
    #
    # To configure the adapter's Kafka brokers, set relevant attributes using the KafkaQueuingBackend.configure method
    # in the config/initializers/kafka_queuing_backend.rb:
    #
    # KafkaQueuingBackend.configure do | config |
    #   config.provider = :kafka
    #   config.brokers  = 'localhost:9092'
    # end
    #
    # The adapter uses a {kafka}[https://github.com/deadmanssnitch/kafka] client to produce jobs.
    class KafkaAdapter
      def enqueue(job) # :nodoc:
        self.enqueue_at(job, nil)
      end

      def enqueue_at(job, timestamp) # :nodoc:
        producer.produce(
          timestamp: timestamp,
          topic: job.queue_name,
          payload: JobWrapper.new(job).data
        )
      end

      class JobWrapper # :nodoc:
        def initialize(job)
          job.provider_job_id = SecureRandom.uuid
          @job_data           = job.serialize
        end

        def perform
          Base.execute @job_data
        end

        def data
          @job_data.to_json
        end
      end

      private
        def producer
          @producer ||= KafkaQueuingBackend::ProducerFactory.create(
            name: ENV.fetch('KAFKA_PRODUCER_NAME', 'Kafka Queuing Backend ActiveJob Queue Adapter')
          )
          @producer
        end
    end

    class KqbAdapter < KafkaAdapter
    end
  end
end
