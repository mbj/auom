# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'auom'
  s.version = '0.1.0'

  s.authors  = ['Markus Schirp']
  s.email    = 'mbj@schirp-dso.com'
  s.summary  = 'Algebra (with) Units Of Measurement'
  s.homepage = 'http://github.com/mbj/auom'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths    = %w[lib]
  s.extra_rdoc_files = %w[TODO LICENSE]

  s.required_ruby_version = '>= 2.1'

  s.add_dependency('equalizer', '~> 0.0.9')

  s.add_development_dependency('devtools', '~> 0.1.12')
end
