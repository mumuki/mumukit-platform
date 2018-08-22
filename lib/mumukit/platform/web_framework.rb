module Mumukit::Platform::WebFramework
  module Rails
    class LazyString
      def initialize(proc)
        @proc = proc
      end

      def to_s
        @proc.call.to_s
      end
    end

    def self.lazy_string(&block)
      LazyString.new(proc(&block))
    end

    def self.configure_tenant_path_routes!(mapper, &block)
      mapper.scope '/:tenant', tenant_scope_options, &block
    end

    def self.tenant_scope_options
      {
          defaults: { tenant: lazy_string { Mumukit::Platform.current_organization_name } },
          constraints: { tenant: Mumukit::Platform::Organization::Helpers.valid_name_regex }
      }
    end
  end

  module Sinatra
    def self.configure_tenant_path_routes!(mapper, &block)
      require 'sinatra/namespace'

      mapper.send :namespace, '/:tenant', &block
    end
  end
end
