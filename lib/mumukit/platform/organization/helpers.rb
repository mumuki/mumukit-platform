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

  def as_platform_json
    {
      name: name,
      book: book.slug,
      banner_url: banner_url,
      breadcrumb_image_url: breadcrumb_image_url,
      community_link: community_link,
      contact_email: contact_email,
      description: description,
      extension_javascript: extension_javascript,
      favicon_url: favicon_url,
      feedback_suggestions_enabled: feedback_suggestions_enabled?,
      immersive: immersive?,
      locale: locale,
      login_methods: login_methods,
      logo_url: logo_url,
      open_graph_image_url: open_graph_image_url,
      public: public?,
      raise_hand_enabled: raise_hand_enabled?,
      terms_of_service: terms_of_service,
      theme_stylesheet: theme_stylesheet
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
        .merge(theme: Mumukit::Platform::Organization::Theme.parse(json))
        .merge(settings: Mumukit::Platform::Organization::Settings.parse(json))
        .merge(profile: Mumukit::Platform::Organization::Profile.parse(json))
    end
  end
end
