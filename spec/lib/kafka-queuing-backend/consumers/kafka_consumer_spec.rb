# frozen_string_literal: true

require 'redpanda_helper'

RSpec.describe KafkaConsumer do
  let(:test_consumer) {
    KafkaConsumer.new(
      name: 'test_consumer',
      group: 'test_consumers_group'
    )
  }

  it 'is defined' do
    expect(described_class).not_to be_nil
  end

  it 'successfully subscribes to a topic' do
    Thread.new do
      Thread.abort_on_exception = true
      expect { test_consumer.subscribe(['default']) }.to output(/The 'test_consumer' consumer is listening topic: default/).to_stdout
    end
  end
end
