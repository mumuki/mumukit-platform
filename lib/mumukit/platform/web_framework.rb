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
      mapper.scope '/:tenant', defaults: {tenant: lazy_string { Mumukit::Platform.current_organization_name }}, &block
    end
  end

  module Sinatra
    def self.configure_tenant_path_routes!(mapper, &block)
      require 'sinatra/namespace'

      mapper.send :namespace, '/:tenant', &block
    end
  end
end
