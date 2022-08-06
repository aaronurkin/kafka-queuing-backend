# frozen_string_literal: true

require "#{Rails.root}/config/environment"
require 'kafka-queuing-backend/task_definition/consumer'

namespace :kqb do
  task :consume do |task, consumers|
    execute_kafka_queuing_backend_consume(consumers)
  end
end

namespace :kafka_queuing_backend do
  task :consume do |task, consumers|
    execute_kafka_queuing_backend_consume(consumers)
  end
end

def execute_kafka_queuing_backend_consume(consumers)
  KafkaQueuingBackend::TaskDefinition::Consumer.consume consumers.to_a
end
