# frozen_string_literal: true

require File.expand_path('lib/kafka-queuing-backend/version', __dir__)

Gem::Specification.new do |spec|
  spec.name                   = 'kafka-queuing-backend'
  spec.version                = KafkaQueuingBackend::VERSION
  spec.authors                = ['Aaron Urkin']
  spec.email                  = ['a.urkin@gmail.com']
  spec.summary                = 'Queuing Backend for Rails applications based on the Kafka event streaming platform.'
  spec.description            = 'This gem provides a Publish/Subscribe pattern implementation using the Kafka event streaming platform.'
  spec.homepage               = 'https://github.com/aaronurkin/kafka-queuing-backend'
  spec.license                = 'MIT'
  spec.required_ruby_version  = Gem::Requirement.new('>= 2.7.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir                 = 'exe'
  spec.executables            = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths          = ['lib']

  spec.metadata               = {
    'rubygems_mfa_required' => 'true'
  }

  spec.add_dependency 'dotenv', '~> 2.7',   '>= 2.7.6'
  spec.add_dependency 'kafka',  '~> 0.5.2'

  spec.add_development_dependency 'rails',                '~> 5.1'
  spec.add_development_dependency 'rake',                 '~> 13.0',  '>= 13.0.6'  
  spec.add_development_dependency 'rspec',                '~> 3.11'
  spec.add_development_dependency 'rubocop',              '~> 1.28',  '>= 1.28.2'
  spec.add_development_dependency 'rubocop-performance',  '~> 1.13',  '>= 1.13.3'
  spec.add_development_dependency 'rubocop-rspec',        '~> 2.10'
end
