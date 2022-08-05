# frozen_string_literal: true

RSpec.describe KafkaDefaultMessageHandler do
  let(:test_message) {
    double(:payload => '{"job_class":"DummyJob","job_id":"0b5a3e0c-a878-4321-afac-3a0aac7acba2","provider_job_id":"b3b83e82-f633-4c84-b4bd-1269f27d4589","queue_name":"test_topic","priority":null,"arguments":["{\"message\":\"Hello from test\"}"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2022-07-12T22:22:12Z"}')
  }

  let(:test_handler) {
    KafkaDefaultMessageHandler.new
  }

  it 'is defined' do
    expect(described_class).not_to be_nil
  end

  it 'handles message properly' do
    test_handler.handle(test_message)
  end
end
