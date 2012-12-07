# -*- encoding: utf-8 -*-
require File.expand_path('../lib/auom/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'auom'
  s.version = AUOM::VERSION.dup

  s.authors  = ['Markus Schirp']
  s.email    = 'mbj@seonic.net'
  s.summary  = 'Algebra (with) Units Of Measurement'
  s.homepage = 'http://github.com/mbj/auom'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths    = %w(lib)
  s.extra_rdoc_files = %w(TODO LICENSE)

  s.rubygems_version = '1.8.10'

  s.add_runtime_dependency('backports', '~> 2.6.3')
  s.add_runtime_dependency('equalizer', '~> 0.0.1')
end
