# frozen_string_literal: true

require 'generators/kafka_queuing_backend/install_generator'

RSpec.describe KafkaQueuingBackend::Generators::InstallGenerator do
  before :all do
    remove_initializer
  end

  after :all do
    remove_initializer
    add_initializer
  end

  it 'installs initializer properly' do
    described_class.start
    expect(File.file?(initializer_file)).to be true
  end
end
