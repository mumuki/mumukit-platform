class Mumukit::Platform::Organization::Profile < Mumukit::Platform::Model
  LOCALES = {
    en: { facebook_code: :en_US, name: 'English' },
    es: { facebook_code: :es_LA, name: 'Español' },
    br: { facebook_code: :pt_BR, name: 'Portugués' }
  }.with_indifferent_access

  model_attr_accessor :logo_url,
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
end
