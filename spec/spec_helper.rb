# frozen_string_literal: true

require 'dotenv/load'

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
require_relative '../spec/dummy/config/environment'
ENV['RAILS_ROOT'] ||= "#{File.dirname(__FILE__)}../../../spec/dummy"

require 'kafka-queuing-backend'
