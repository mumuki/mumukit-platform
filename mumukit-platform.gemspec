# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mumukit/platform/version'

Gem::Specification.new do |spec|
  spec.name          = 'mumukit-platform'
  spec.version       = Mumukit::Platform::VERSION
  spec.authors       = ['Franco Leonardo Bulgarelli']
  spec.email         = ['franco@mumuki.org']

  spec.summary       = %q{Shared Mumuki Platform Components}
  spec.description   = %q{Library for accessing shared models of the Mumuki Platform}
  spec.homepage      = 'https://mumuki.io'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'mumukit-nuntius', '~> 6.0'
  spec.add_dependency 'mumukit-core', '~> 1.20'
  spec.add_dependency 'mumukit-auth', '~> 7.6'
  spec.add_dependency 'mumukit-bridge', '~> 4.2'
  spec.add_dependency 'activemodel', '>= 6.0', '< 8'

  spec.add_development_dependency 'bundler', '>= 1.7', '< 3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.required_ruby_version = '>= 3.0'
end
