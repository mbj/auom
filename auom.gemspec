# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'auom'
  s.version = '0.0.6'

  s.authors  = ['Markus Schirp']
  s.email    = 'mbj@schirp-dso.com'
  s.summary  = 'Algebra (with) Units Of Measurement'
  s.homepage = 'http://github.com/mbj/auom'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths    = %w(lib)
  s.extra_rdoc_files = %w(TODO LICENSE)

  s.rubygems_version = '1.8.10'

  s.add_dependency('backports', [ '~> 3.0', '>= 3.0.3' ])
  s.add_dependency('equalizer', '~> 0.0.5')
end
