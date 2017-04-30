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

def new_rack_request(protocol, host, port = '80', path = '/')
  Rack::Request.new 'HTTP_HOST' => host,
                    'rack.url_scheme' => protocol,
                    'SERVER_PORT' => port,
                    'PATH_INFO' => path
end

Mumukit::Platform.configure do |config|
  config.application = Mumukit::Platform::Application::Organic.new 'http://sample.app.com', Mumukit::Platform.organization_mapping
end