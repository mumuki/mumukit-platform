
module Mumukit::Platform::Organization::Helpers
  extend ActiveSupport::Concern

  included do
    delegate :theme_stylesheet_url,
             :extension_javascript_url, to: :theme

    delegate :login_methods,
             :login_methods=,
             :login_settings,
             :raise_hand_enabled?,
             :raise_hand_enabled=,
             :public?,
             :public=,
             :private?, to: :settings

    delegate :logo_url,
             :logo_url=,
             :locale,
             :locale=,
             :locale_json,
             :description,
             :description=,
             :community_link,
             :terms_of_service,
             :terms_of_service=,
             :contact_email,
             :contact_email=, to: :profile

  end

  def slug
    Mumukit::Auth::Slug.join_s name
  end

  def central?
    name == 'central'
  end

  def test?
    name == 'test'
  end

  def switch!
    Mumukit::Platform::Organization.switch! self
  end

  def to_s
    name
  end

  def url_for(path)
    Mumukit::Platform.application.organic_url_for(name, path)
  end

  def domain
    Mumukit::Platform.application.organic_domain(name)
  end

  module ClassMethods
    def current
      Mumukit::Platform::Organization.current
    end

    def parse(json)
      json
        .slice(:name)
        .merge(theme: Mumukit::Platform::Organization::Theme.parse(json))
        .merge(settings: Mumukit::Platform::Organization::Settings.parse(json))
        .merge(profile: Mumukit::Platform::Organization::Profile.parse(json))
    end
  end
end
