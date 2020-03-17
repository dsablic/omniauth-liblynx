# frozen_string_literal: true

require File.expand_path('lib/omniauth-liblynx/version', __dir__)

Gem::Specification.new do |gem|
  gem.authors       = ['Denis Sablic']
  gem.email         = ['denis.sablic@gmail.com']
  gem.homepage      = 'https://github.com/dsablic/omniauth-liblynx'
  gem.summary       = 'OmniAuth strategy for LibLynx'
  gem.license       = 'MIT'
  gem.required_ruby_version = '>= 2.3.0'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'omniauth-liblynx'
  gem.require_paths = ['lib']
  gem.version       = OmniAuth::LibLynx::VERSION

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake', '< 14.0'
  gem.add_development_dependency 'rubocop'

  gem.add_dependency 'omniauth', '~> 1.9'
  gem.add_dependency 'omniauth-oauth2', '>= 1.4.0', '< 2.0'
end
