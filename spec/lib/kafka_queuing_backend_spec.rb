# frozen_string_literal: true

RSpec.describe KafkaQueuingBackend do
  it 'has version number' do
    expect(described_class::VERSION).not_to be_nil
  end
end
