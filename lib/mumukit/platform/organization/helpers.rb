module Mumukit::Platform::Organization::Helpers
  extend ActiveSupport::Concern
  include Mumukit::Platform::Notifiable

  ## Implementors must declare the following methods:
  #
  #  * name
  #  * book
  #  * profile
  #  * settings
  #  * theme

  included do
    delegate :theme_stylesheet,
             :theme_stylesheet=,
             :extension_javascript,
             :extension_javascript=, to: :theme

    delegate :login_methods,
             :login_methods=,
             :login_provider,
             :login_provider=,
             :provider_settings,
             :provider_settings=,
             :login_settings,
             :feedback_suggestions_enabled?,
             :feedback_suggestions_enabled=,
             :raise_hand_enabled?,
             :raise_hand_enabled=,
             :forum_enabled?,
             :forum_enabled=,
             :report_issue_enabled?,
             :report_issue_enabled=,
             :public?,
             :public=,
             :embeddable?,
             :embeddable=,
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
             :community_link=,
             :terms_of_service,
             :terms_of_service=,
             :contact_email,
             :contact_email=,
             :errors_explanations,
             :errors_explanations=, to: :profile

  end

  def platform_class_name
    :Organization
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

  ## API Exposure

  def to_param
    name
  end

  ## Name validation

  def self.valid_name?(name)
    !!(name =~ anchored_valid_name_regex)
  end

  def self.anchored_valid_name_regex
    /\A#{valid_name_regex}\z/
  end

  def self.valid_name_regex
    /([-a-z0-9_]+(\.[-a-z0-9_]+)*)?/
  end

  ## Platform JSON

  def self.slice_platform_json(json)
    json.slice(:name, :book, :profile, :settings, :theme)
  end

  def as_platform_json
    {
      name: name,
      book: book.slug,
      profile: profile,
      settings: settings,
      theme: theme
    }.except(*protected_platform_fields).compact
  end

  def protected_platform_fields
    []
  end

  module ClassMethods
    def current
      Mumukit::Platform::Organization.current
    end

    def parse(json)
      json
        .slice(:name)
        .merge(theme: Mumukit::Platform::Organization::Theme.parse(json[:theme]))
        .merge(settings: Mumukit::Platform::Organization::Settings.parse(json[:settings]))
        .merge(profile: Mumukit::Platform::Organization::Profile.parse(json[:profile]))
    end
  end
end
