module Mumukit::Platform::Domain
  def self.from_env
    if ENV['RACK_ENV'] == 'test' || ENV['RAILS_ENV'] == 'test'
      'localmumuki.io'
    else
      ENV['MUMUKI_PLATFORM_DOMAIN'] || 'mumuki.io'
    end
  end
end