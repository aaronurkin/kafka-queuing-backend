# frozen_string_literal: true

require 'kafka'
require 'securerandom'
require 'kafka-queuing-backend/message_handler_factory'

class KafkaConsumer
  attr_reader :id, :name

  def initialize(name:, options: {})
    @id       = SecureRandom.uuid
    @name     = name
    @options  = options
    @thread   = Thread.current
    @instance = Kafka::Consumer.new(Kafka::Config.new(options))
  end

  def subscribe(topics)
    raise 'At least one topic required' if topics.nil? || topics.empty?

    @instance.subscribe(topics)

    Signal.trap(:INT)   { self.stop }
    Signal.trap(:TERM)  { self.stop }

    message_handler = KafkaQueuingBackend::MessageHandlerFactory.create

    puts  "[#{@thread.object_id}]:\tThe '#{@name}' consumer "\
          "is listening topic#{topics.count > 1 ? 's' : ''}: #{topics.join(', ')}"
    puts  "Use Ctrl-C to stop"

    loop do
      @instance.poll do | message |
        message_handler.handle(message)
        @instance.commit(message, async: true) if @options.disable_auto_commit
      rescue => error
        Rails.logger.error "FAILED handling a message from '#{message.topic}' topic. Error: #{error}\n#{error.backtrace.join("\n")}"
      end
    ensure
      break unless @thread.alive?
    end
  ensure
    @instance.close unless @instance.nil?
  end

  def group
    @options.fetch(:'group.id')
  end

  def stop
    unless @thread.nil?
      @thread.join(0.1)
      @thread.terminate
      sleep(0.001) while @thread.alive?
      puts "\nThe '#{@name}' consumer has successfully been stopped"
    else
      puts "The thread doesn't exist"
    end
  end
end
