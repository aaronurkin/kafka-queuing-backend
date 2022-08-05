# frozen_string_literal: true

require 'redpanda_helper'

RSpec.describe ActiveJob::QueueAdapters::KafkaTestAdapter do

  subject(:test_job) { DummyJob.perform_later("test message") }

  it 'is defined' do
    expect(described_class).to_not be nil
  end

  it "enqueues the job" do
    ActiveJob::Base.queue_adapter = :kafka_test
    expect{ test_job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end
end
