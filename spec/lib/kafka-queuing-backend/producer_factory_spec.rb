# frozen_string_literal: true

require 'redpanda_helper'

RSpec.describe KafkaQueuingBackend::ProducerFactory do

  before(:all) do
    KafkaQueuingBackend.configure do | config |
      config.provider = :kafka
      config.brokers  = 'localhost:9092'
    end
  end

  it 'is defined' do
    expect(described_class).not_to be_nil
  end

  it 'creates a producer using the kafka gem' do
    producer = described_class.create name: 'test_producer'
    expect(producer).not_to be_nil
    expect(producer.name).to eq('test_producer')
  end
end
