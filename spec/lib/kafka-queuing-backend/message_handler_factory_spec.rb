# frozen_string_literal: true

RSpec.describe KafkaQueuingBackend::MessageHandlerFactory do
  it 'is defined' do
    expect(described_class).not_to be_nil
  end

  it 'creates a message handler handling the kafka gem messages' do
    handler = described_class.create
    expect(handler).not_to be_nil
  end
end
