
module Mumukit::Platform::Organization::Helpers
  extend ActiveSupport::Concern

  included do
    delegate :theme_stylesheet,
             :extension_javascript, to: :theme

    delegate :login_methods,
             :login_methods=,
             :login_settings,
             :feedback_suggestions_enabled?,
             :feedback_suggestions_enabled=,
             :raise_hand_enabled?,
             :raise_hand_enabled=,
             :public?,
             :public=,
             :immersive?,
             :immersive=,
             :private?, to: :settings

    delegate :logo_url,
             :logo_url=,
             :banner_url,
             :banner_url=,
             :open_graph_image_url,
             :open_graph_image_url=,
             :favicon_url,
             :favicon_url=,
             :breadcrumb_image_url,
             :breadcrumb_image_url=,
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

  def base?
    name == 'base'
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

  def self.valid_name?(name)
    !!(name =~ anchored_valid_name_regex)
  end

  def self.anchored_valid_name_regex
    /\A#{valid_name_regex}\z/
  end

  def self.valid_name_regex
    /([-a-z0-9_]+(\.[-a-z0-9_]+)*)?/
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
