ENV['RACK_ENV'] = 'test'

require 'bundler/setup'
require 'mumukit/platform'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


Mumukit::Platform.configure do |config|
  config.application = Mumukit::Platform::Application::Organic.new 'http://sample.app.com'
end