# frozen_string_literal: true

RSpec.describe KafkaQueuingBackend do
  it 'has version number' do
    expect(described_class::VERSION).not_to be_nil
  end

  it 'is configurable' do
    described_class.configure do | config |
      expect(config).to eq(described_class)
    end
  end

  context 'is configured' do
    before(:all) do
      described_class.configure do | config |
        config.provider   = :kafka
        config.brokers    = 'localhost:9092'
        config.consumers  = [
          {
            name: 'first_consumer',
            group: 'test_consumers_group',
            topics: [
              'test_topic_1'
            ]
          }
        ]
      end
    end

    it 'provider' do
      expect(described_class.provider).not_to be_nil
      expect(described_class.provider).not_to be_empty
    end

    it 'brokers' do
      expect(described_class.brokers).not_to be_nil
      expect(described_class.brokers).not_to be_empty
    end

    it 'consumers' do
      expect(described_class.consumers).not_to be_nil
      expect(described_class.consumers).not_to be_empty
    end
  end

  context 'is not configured' do
    before(:all) do
      described_class.configure do | config |
        config.provider = nil
        config.brokers = nil
        config.consumers = nil
      end
    end

    it 'provider' do
      expect { described_class.provider() }.to raise_error(KafkaQueuingBackend::MissingConfigurationError)
    end

    it 'brokers' do
      expect { described_class.brokers() }.to raise_error(KafkaQueuingBackend::MissingConfigurationError)
    end

    it 'consumers' do
      expect { described_class.consumers() }.to raise_error(KafkaQueuingBackend::MissingConfigurationError)
    end
  end
end
