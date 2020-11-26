require 'pathname'

module Mumukit::Platform::OrganizationMapping
  def self.from_env
    if ENV['RACK_ENV'] == 'test' || ENV['RAILS_ENV'] == 'test'
      Subdomain
    else
      parse ENV['MUMUKI_ORGANIZATION_MAPPING']
    end
  end

  def self.parse(name)
    mapping = name.try { |it| it.strip.downcase }
    if mapping.blank? || mapping == 'path'
      Path
    elsif mapping == 'subdomain'
      Subdomain
    else
      raise "Unrecognized organization mapping #{mapping}"
    end
  end

  module Base
    def path_for(request)
      request.path_info
    end
  end

  module Subdomain
    extend Base

    def self.implicit_organization?(request, domain)
      request.empty_subdomain_after?(domain)
    end

    def self.map_organization_routes!(native, _framework, &block)
      native.instance_eval(&block)
    end

    def self.organization_name(request, domain)
      request.subdomain_after(domain) || 'central'
    end

    def self.organic_uri(uri, organization)
      uri.subdominate(organization)
    end

    def self.path_under_namespace?(_organization_name, path, namespace)
      path.start_with? "/#{namespace}/"
    end

    def self.inorganic_path_for(request)
      path_for(request)
    end
  end

  module Path
    extend Base

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
      uri.tenantize organization
    end

    def self.path_under_namespace?(organization_name, path, namespace)
      path.start_with? "/#{organization_name}/#{namespace}/"
    end
  end
end
