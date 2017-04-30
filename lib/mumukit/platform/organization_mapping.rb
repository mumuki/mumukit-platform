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
    def self.configure_application_routes!(native, _framework, &block)
      native.instance_eval(&block)
    end

    def self.extract_organization_name(request)
      request.first_subdomain_after(Mumukit::Platform.application.domain) || 'central'
    end
  end

  module Path
    def self.configure_application_routes!(native, framework, &block)
      framework.configure_tenant_path_routes! native, &block
    end

    def self.extract_organization_name(request)
      request.path.split('/')[1]
    end
  end
end