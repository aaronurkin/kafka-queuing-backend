# frozen_string_literal: true

require "spec_helper"

DOCKER_CONTAINER_NAME_REDPANDA = 'redpanda-1'

RSpec.configure do |config|
  config.after(:suite) do
    system("docker stop #{DOCKER_CONTAINER_NAME_REDPANDA}")
  end

  config.before(:suite) do
    system(
      "docker run -d --pull=always --name=#{DOCKER_CONTAINER_NAME_REDPANDA} --rm "\
      "-p 8081:8081 "\
      "-p 8082:8082 "\
      "-p 9092:9092 "\
      "-p 9644:9644 "\
      "docker.redpanda.com/vectorized/redpanda:latest "\
      "redpanda start "\
      "--overprovisioned "\
      "--smp 1 "\
      "--memory 1G "\
      "--reserve-memory 0M "\
      "--node-id 0 "\
      "--check=false"
    )
  end

  require 'active_job/queue_adapters'
  require_relative 'lib/active_job/queue_adapters/kafka_test_adapter'
  config.include ActiveJob::TestHelper
end
