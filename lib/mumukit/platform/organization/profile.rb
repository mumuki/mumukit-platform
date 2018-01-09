class Mumukit::Platform::Organization::Profile < Mumukit::Platform::Model
  LOCALES = {
    en: { facebook_code: :en_US, name: 'English' },
    es: { facebook_code: :es_LA, name: 'Español' },
    br: { facebook_code: :pt_BR, name: 'Português' }
  }.with_indifferent_access

  model_attr_accessor :logo_url,
                      :banner_url,
                      :favicon_url,
                      :breadcrumb_image_url,
                      :open_graph_image_url,
                      :locale,
                      :description,
                      :contact_email,
                      :terms_of_service,
                      :community_link

  def locale_json
    LOCALES[locale].to_json
  end

  def logo_url
    @logo_url ||= 'https://mumuki.io/logo-alt-large.png'
  end

  def banner_url
    @banner_url ||= logo_url
  end

  def favicon_url
    @favicon_url ||= '/favicon.ico'
  end

  def open_graph_image_url
    @open_graph_image_url ||= "#{Mumukit::Platform.application.url}/logo-alt.png"
  end
end
