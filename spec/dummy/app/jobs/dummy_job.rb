class DummyJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "DummyJob.perform args: #{args}"
  end
end
