module Mumukit::Platform::WithPathMapping
  def implicit_organization?(request)
    Mumukit::Platform::PathMapping.implicit_organization? request, application.domain
  end

  def organization_name(request)
    Mumukit::Platform::PathMapping.organization_name(request, application.domain)
  end

  def map_organization_routes!(native_mapper, &block)
    Mumukit::Platform::PathMapping.map_organization_routes!(native_mapper, web_framework, &block)
  end
end
