# frozen_string_literal: true

module RakeUtils
  def execute_kqb_consume(consumers)
    Rake::Task['kqb:consume'].execute consumers
  end

  def execute_kafka_queuing_backend_consume(consumers)
    Rake::Task['kafka_queuing_backend:consume'].execute consumers
  end
end
