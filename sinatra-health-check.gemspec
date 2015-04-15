# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sinatra-health-check/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "sinatra-health-check"
  gem.version       = SinatraHealthCheck::VERSION
  gem.authors       = ["Felix Bechstein"]
  gem.email         = %w{felix.bechstein@otto.de}
  gem.description   = %q{A simple health check for sinatra applications}
  gem.summary       = %q{This health check adds graceful stop to your sinatra applications}
  gem.homepage      = 'https://github.com/otto-de/sinatra-health-check'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w{lib}

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rspec-its'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'cane'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'codeclimate-test-reporter'
end
