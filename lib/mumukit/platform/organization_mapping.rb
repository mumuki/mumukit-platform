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
    if mapping.blank? || mapping == 'subdomain'
      Subdomain
    elsif mapping == 'path'
      Path
    else
      raise "Unrecognized organization mapping #{mapping}"
    end
  end

  module Subdomain
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
  end

  module Path
    def self.implicit_organization?(_request, _domain)
      false
    end

    def self.map_organization_routes!(native, framework, &block)
      framework.configure_tenant_path_routes! native, &block
    end

    def self.organization_name(request, _domain)
      request.path.split('/')[1]
    end

    def self.organic_uri(uri, organization)
      uri.subroute(organization)
    end

    def self.path_under_namespace?(organization_name, path, namespace)
      path.start_with? "/#{organization_name}/#{namespace}/"
    end
  end
end
