module Mumukit::Platform::Locale
  SPECS = {
    en: { facebook_code: :en_US, auth0_code: :en, name: 'English' },
    es: { facebook_code: :es_LA, auth0_code: :es, name: 'Español' },
    pt: { facebook_code: :pt_BR, auth0_code: 'pt-br', name: 'Português' }
  }.with_indifferent_access

  def self.supported
    SPECS.keys
  end
end
