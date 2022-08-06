# frozen_string_literal: true

RSpec.describe 'Rake Tasks' do
  describe 'task subscribing configured consumer to their topics' do
    let(:consumers) {
      KafkaQueuingBackend.consumers.map { | consumer | consumer.fetch(:name) }
    }

    let(:regex) {
      /(configuration was not found)|(The group must be configured)|(At least one topic must be configured)|(FAILED)/
    }

    context 'invokes with correct argumets' do
      it 'short task name' do
        Thread.new do
          Thread.abort_on_exception = true
          expect { execute_kqb_consume(consumers) }.to output(/brokers are down/).to_stdout
        end
      end

      it 'full task name' do
        Thread.new do
          Thread.abort_on_exception = true
          expect { execute_kafka_queuing_backend_consume(consumers) }.to output(/brokers are down/).to_stdout
        end
      end
    end

    context 'fails when invalid arguments' do
      context 'execute_kqb_consume method fails' do
        it 'without arguments' do
          Thread.new do
            Thread.abort_on_exception = true
            expect { execute_kqb_consume }.to raise_error(ArgumentError)
          end
        end

        it 'empty array' do
          Thread.new do
            Thread.abort_on_exception = true
            expect { execute_kqb_consume([]) }.to raise_error(ArgumentError)
          end
        end
      end

      context 'execute_kafka_queuing_backend_consume method' do
        it 'without arguments' do
          Thread.new do
            Thread.abort_on_exception = true
            expect { execute_kafka_queuing_backend_consume }.to raise_error(ArgumentError)
          end
        end

        it 'empty array' do
          Thread.new do
            Thread.abort_on_exception = true
            expect { execute_kafka_queuing_backend_consume([]) }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
