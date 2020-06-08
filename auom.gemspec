# frozen_string_literal: true

Gem::Specification.new do |gem|
  gem.name = 'auom'
  gem.version = '0.3.1'

  gem.authors  = ['Markus Schirp']
  gem.email    = 'mbj@schirp-dso.com'
  gem.summary  = 'Algebra (with) Units Of Measurement'
  gem.homepage = 'http://github.com/mbj/auom'

  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths    = %w[lib]
  gem.extra_rdoc_files = %w[LICENSE]

  gem.required_ruby_version = '>= 2.5'

  gem.add_dependency('equalizer', '~> 0.0.9')

  gem.add_development_dependency('devtools',        '~> 0.1.26')
  gem.add_development_dependency('minitest',        '~> 5.11.3')
  gem.add_development_dependency('mutant',          '~> 0.9.7')
  gem.add_development_dependency('mutant-minitest', '~> 0.9')
  gem.add_development_dependency('mutant-rspec',    '~> 0.9')
end
