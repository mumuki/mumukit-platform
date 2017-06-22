
module Mumukit::Platform::Organization::Helpers
  extend ActiveSupport::Concern

  included do
    delegate :logo_url,
             :theme_stylesheet_url,
             :extension_javascript_url, to: :theme

    delegate :login_methods,
             :login_methods=,
             :login_settings,
             :raise_hand_enabled?,
             :raise_hand_enabled=,
             :public?,
             :public=,
             :private?, to: :settings

    delegate :locale,
             :locale=,
             :locale_json,
             :description,
             :description=,
             :community_link,
             :terms_of_service,
             :terms_of_service=,
             :contact_email,
             :contact_email=, to: :community

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
        .merge(theme: Mumukit::Platform::Theme.parse(json))
        .merge(settings: Mumukit::Platform::Settings.parse(json))
        .merge(community: Mumukit::Platform::Community.parse(json))
    end
  end
end
