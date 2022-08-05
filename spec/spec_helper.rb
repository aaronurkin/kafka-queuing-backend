# frozen_string_literal: true

require 'dotenv/load'

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
require_relative '../spec/dummy/config/environment'
ENV['RAILS_ROOT'] ||= "#{File.dirname(__FILE__)}../../../spec/dummy"

# Support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

require 'kafka-queuing-backend'

RSpec.configure do |config|
  config.include FileManager
end

include FileManager
add_initializer
