# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sunits/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'sunits'
  s.version = SUnits::VERSION.dup

  s.authors  = ['Markus Schirp']
  s.email    = 'mbj@seonic.net'
  s.summary  = 'Small ruby-units replacement'
  s.homepage = 'http://github.com/mbj/sunits'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths    = %w(lib)
  s.extra_rdoc_files = %w(TODO LICENSE)

  s.rubygems_version = '1.8.10'

  s.add_runtime_dependency('virtus', '~> 0.2.0')

  s.add_development_dependency('rspec',     '~> 2.8.0')
end
