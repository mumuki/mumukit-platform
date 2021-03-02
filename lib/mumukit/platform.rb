require 'mumukit/core'
require 'mumukit/auth'
require 'mumukit/nuntius'
require 'mumukit/bridge'

require_relative './platform/version'
require_relative './platform/uri'

module Mumukit::Platform
  extend Mumukit::Core::Configurable

  CORE_MODELS = [:organization, :user, :course]

  def self.defaults
    struct.tap do |config|
      domain = Mumukit::Platform::Domain.from_env

      config.laboratory_url = ENV['MUMUKI_LABORATORY_URL'] || "http://#{domain}"
      config.thesaurus_url = ENV['MUMUKI_THESAURUS_URL'] || "http://thesaurus.#{domain}"
      config.bibliotheca_ui_url = ENV['MUMUKI_BIBLIOTHECA_UI_URL'] || "http://bibliotheca.#{domain}"
      config.bibliotheca_api_url = ENV['MUMUKI_BIBLIOTHECA_API_URL'] || "http://bibliotheca-api.#{domain}"
      config.classroom_ui_url = ENV['MUMUKI_CLASSROOM_UI_URL'] || "http://classroom.#{domain}"
      config.classroom_api_url = ENV['MUMUKI_CLASSROOM_API_URL'] || "http://classroom-api.#{domain}"
      config.organization_mapping = Mumukit::Platform::OrganizationMapping.from_env
    end
  end

  CORE_MODELS.each do |klass|
    # Configured classes must implement the following methods:
    #
    # _organization_:
    #   * `#name`
    #   * `#locale`
    #   * `.find_by_name!`
    #
    # _user_:
    #   * `.find_by_uid!`
    #
    # _course_:
    #   * `.find_by_slug!`
    #
    define_singleton_method("#{klass}_class") do
      begin
        return config["#{klass}_class"] if config["#{klass}_class"].present?
        config["#{klass}_class_name"].to_s.constantize.tap do |klass_instance|
          config["#{klass}_class"] = klass_instance unless %w(RACK_ENV RAILS_ENV).any? { |it| ENV[it] == 'development' }
        end
      rescue NameError => e
        raise "You must configure your #{klass} class first"
      end
    end
  end
end

require_relative './platform/notifiable'

require_relative './platform/global'
require_relative './platform/domain'
require_relative './platform/model'
require_relative './platform/locale'
require_relative './platform/course'
require_relative './platform/organization'
require_relative './platform/user'
require_relative './platform/organization_mapping'
require_relative './platform/application'
require_relative './platform/web_framework'
require_relative './platform/bridge'

require_relative './platform/with_organization'
require_relative './platform/with_applications'
require_relative './platform/with_organization_mapping'
require_relative './platform/with_web_framework'

module Mumukit::Platform
  extend Mumukit::Platform::WithApplications
  extend Mumukit::Platform::WithOrganization
  extend Mumukit::Platform::WithOrganizationMapping
  extend Mumukit::Platform::WithWebFramework
end
