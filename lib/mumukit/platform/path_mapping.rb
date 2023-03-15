require 'pathname'

module Mumukit::Platform::PathMapping
  def self.path_for(request)
    request.path_info
  end

  def self.implicit_organization?(_request, _domain)
    false
  end

  def self.map_organization_routes!(native, framework, &block)
    framework.configure_tenant_path_routes! native, &block
  end

  def self.path_composition_for(request)
    organization, *path_parts = Pathname(path_for(request)).each_filename.to_a
    [organization, path_parts.join('/')]
  end

  def self.organization_name(request, _domain)
    path_composition_for(request).first
  end

  def self.inorganic_path_for(request)
    path_composition_for(request).second
  end

  def self.organic_uri(uri, organization)
    uri.tenantize organization, fragmented: true
  end

  def self.path_under_namespace?(organization_name, path, namespace)
    path.start_with? "/#{organization_name}/#{namespace}/"
  end
end
