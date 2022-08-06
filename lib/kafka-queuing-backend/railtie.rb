# frozen_string_literal: true

require 'rake'
require 'rails/railtie'

module KafkaQueuingBackend
  # Load Rake tasks
  class Railtie < Rails::Railtie
    rake_tasks do
        load 'tasks/kafka_queuing_backend_tasks.rake'
    end
  end
end
