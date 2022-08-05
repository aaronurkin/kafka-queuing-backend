# frozen_string_literal: true

require 'redpanda_helper'

RSpec.describe KafkaQueuingBackend::ConsumerFactory do

  before(:all) do
    KafkaQueuingBackend.configure do | config |
      config.provider = :kafka
      config.brokers  = 'localhost:9092'
    end
  end

  let(:test_consumer) {
    {
      name: 'test_consumer',
      group: 'test_consumers_group',
    }
  }

  it 'is defined' do
    expect(described_class).not_to be_nil
  end

  it 'creates a consumer using the kafka gem' do
    consumer = described_class.create(
      name: test_consumer.fetch(:name),
      group: test_consumer.fetch(:group),
      options: { disable_auto_commit: true }
    )
    expect(consumer).not_to be_nil
    expect(consumer.name).to eq(test_consumer.fetch(:name))
  end
end
