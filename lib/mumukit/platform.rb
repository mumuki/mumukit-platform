require 'mumukit/core'

require_relative './platform/version'
require_relative './platform/uri'

module Mumukit::Platform
  def self.configure
    @config ||= defaults
    yield @config
  end

  def self.defaults
    struct.tap do |config|
      domain = Mumukit::Platform::Domain.from_env

      config.laboratory_url = ENV['MUMUKI_LABORATORY_URL'] || "http://#{domain}"
      config.thesaurus_url = ENV['MUMUKI_THESAURUS_URL'] || "http://thesaurus.#{domain}"
      config.bibliotheca_url = ENV['MUMUKI_BIBLIOTHECA_URL'] || "http://bibliotheca.#{domain}"
      config.bibliotheca_api_url = ENV['MUMUKI_BIBLIOTHECA_API_URL'] || "http://bibliotheca-api.#{domain}"
      config.office_url = ENV['MUMUKI_OFFICE_URL'] || "http://office.#{domain}"
      config.classroom_url = ENV['MUMUKI_CLASSROOM_URL'] || "http://classroom.#{domain}"
      config.classroom_api_url = ENV['MUMUKI_CLASSROOM_API_URL'] || "http://classroom-api.#{domain}"
      config.organization_mapping = Mumukit::Platform::OrganizationMapping.from_env
    end
  end

  def self.config
    @config
  end
end

require_relative './platform/domain'
require_relative './platform/organization_mapping'
require_relative './platform/application'
require_relative './platform/web_framework'

require_relative './platform/with_applications'
require_relative './platform/with_organization_mapping'
require_relative './platform/with_web_framework'

module Mumukit::Platform
  extend Mumukit::Platform::WithApplications
  extend Mumukit::Platform::WithOrganizationMapping
  extend Mumukit::Platform::WithWebFramework
end