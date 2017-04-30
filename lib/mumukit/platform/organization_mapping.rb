module Mumukit::Platform::OrganizationMapping
  def self.from_env
    mapping = ENV['MUMUKI_ORGANIZATION_MAPPING']&.strip
    if ENV['RACK_ENV'] == 'test' || ENV['RAILS_ENV'] == 'test' || mapping == 'subdomain'
      Subdomain
    elsif mapping == 'path'
      Path
    else
      raise "Unrecognized organization mapping #{mapping}"
    end
  end

  module Subdomain
    def self.map_organization_routes!(native, _framework, &block)
      native.instance_eval(&block)
    end

    def self.organization_name(request, domain)
      request.first_subdomain_after(domain) || 'central'
    end

    def self.organic_uri(uri, organization)
      uri.subdominate(organization)
    end
  end

  module Path
    def self.map_organization_routes!(native, framework, &block)
      framework.configure_tenant_path_routes! native, &block
    end

    def self.organization_name(request, _domain)
      request.path.split('/')[1]
    end

    def self.organic_uri(uri, organization)
      uri.subroute(organization)
    end
  end
end