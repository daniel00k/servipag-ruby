# -*- encoding: utf-8 -*-
require File.expand_path('../lib/servipag/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["daniel00k"]
  gem.email         = ["soulreborn2@gmail.com"]
  gem.description   = %q{Ruby client for servipag API}
  gem.summary       = %q{Servipag Wrapper}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "servipag"
  gem.require_paths = ["lib"]
  gem.version       = Servipag::VERSION
  gem.add_dependency 'rest-client'
  gem.add_dependency 'nokogiri'
  gem.add_development_dependency "rspec"
  gem.add_development_dependency 'rake'
end
