# frozen_string_literal: true

require 'dotenv/load'
require 'rails/generators'

module KafkaQueuingBackend
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)
      desc 'Creates the KafkaQueuingBackend initializer file'

      def copy_initializer
        template 'kafka_queuing_backend_initializer.rb',
                 ENV.fetch('KAFKA_QUEUING_BACKEND_INITIALIZER_PATH', "#{Rails.root}/config/initializers/kafka_queuing_backend.rb")
      end
    end
  end
end
