module Mumukit::Platform::WithOrganizationMappings
  delegate :organization_mapping, to: :config

  def organization_name(request)
    organization_mapping.extract_organization_name(request)
  end

  def map_organization_routes!(native_mapper, &block)
    organization_mapping.configure_application_routes!(native_mapper, config.web_framework, &block)
  end
end
