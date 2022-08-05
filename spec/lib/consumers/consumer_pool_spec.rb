# frozen_string_literal: true

require 'redpanda_helper'

RSpec.describe KafkaQueuingBackend::ConsumerPool do
  it 'is defined' do
    expect(described_class).to_not be nil
  end

  after(:each) do
    described_class.stop_all
  end

  let(:test_consumer) {
    if @test_consumer.nil?
      @test_consumer = KafkaQueuingBackend.consumers.first
    end
    @test_consumer
  }

  let(:another_test_consumer) {
    if @another_test_consumer.nil?
      @another_test_consumer = KafkaQueuingBackend.consumers.drop(1).first
    end
    @another_test_consumer
  }

  it 'successfully adds a consumer only once' do
    Thread.new do
      Thread.abort_on_exception = true
      expect { described_class.add(test_consumer) }.to change{ described_class.count }.by(1)
      expect { described_class.add(test_consumer) }.to_not change { described_class.count }
    end
  end

  it 'successfully stopps a consumer' do
    Thread.new do
      Thread.abort_on_exception = true
      expect { described_class.add(test_consumer) }.to change{ described_class.count }.by(1)
      expect { described_class.stop(test_consumer[:name]) }.to change{ described_class.count }.by(-1)
    end
  end

  it 'successfully stopps all the consumers' do
    Thread.new do
      Thread.abort_on_exception = true
      expect { described_class.add(test_consumer) }.to change{ described_class.count }.by(1)
      expect { described_class.add(another_test_consumer) }.to change{ described_class.count }.by(1)
      expect(described_class.count).to eq 2
      described_class.stop_all
      expect(described_class.count).to eq 0
    end
  end

  it 'successfully stopps a consumer started in another thread' do
    Thread.new do
      Thread.abort_on_exception = true
      Thread.new do
        Thread.abort_on_exception = true
        sleep 0.3
        expect { described_class.add(test_consumer) }.to change{ described_class.count }.by(1)
      end.join

      Thread.new do
        Thread.abort_on_exception = true
        sleep 0.5
        puts "count before stop: #{described_class.count}"
        expect { described_class.stop(test_consumer[:name]) }.to change{ described_class.count }.by(-1)
      end.join
    end
  end

  it 'successfully stopps all the consumers started in another thread' do
    Thread.new do
      Thread.abort_on_exception = true
      Thread.new do
        Thread.abort_on_exception = true
        expect { described_class.add(test_consumer) }.to change{ described_class.count }.by(1)
        expect { described_class.add(another_test_consumer) }.to change{ described_class.count }.by(1)
        expect(described_class.count).to eq 2
      end.join

      Thread.new do
        Thread.abort_on_exception = true
        sleep 0.1
        described_class.stop_all
        expect(described_class.count).to eq 0
      end.join
    end
  end
end