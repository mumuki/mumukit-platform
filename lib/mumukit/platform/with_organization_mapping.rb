module Mumukit::Platform::WithOrganizationMapping
  delegate :organization_mapping, to: :config

  def organization_name(request)
    organization_mapping.organization_name(request, application.domain)
  end

  def map_organization_routes!(native_mapper, &block)
    organization_mapping.map_organization_routes!(native_mapper, web_framework, &block)
  end
end
