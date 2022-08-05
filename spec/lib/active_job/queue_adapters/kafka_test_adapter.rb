# frozen_string_literal: true

module ActiveJob
  module QueueAdapters
    class KafkaTestAdapter < ActiveJob::QueueAdapters::KafkaAdapter
      def enqueued_jobs
        if @enqueued_jobs.nil?
            @enqueued_jobs = []
        end
        @enqueued_jobs
      end

      def enqueue(job)
        super
      end

      def enqueue_at(job, timestamp)
        super
        enqueued_jobs << job
      end
    end

    class KqpTestAdapter < KafkaTestAdapter
    end
  end
end
