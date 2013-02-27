# -*- encoding: utf-8 -*-
require './lib/spirit/version'

Gem::Specification.new do |gem|

  # NAME
  gem.name          = 'spirit'
  gem.version       = Spirit::VERSION
  gem.platform      = Gem::Platform::RUBY

  # LICENSES
  gem.license       = 'MIT'
  gem.authors       = ['Jiunn Haur Lim']
  gem.email         = ['codex.is.poetry@gmail.com']
  gem.description   = %q{Parses Genie Markup Language}
  gem.summary       = %q{Parses Genie Markup Language}
  gem.homepage      = 'https://github.com/jimjh/genie-parser'

  # PATHS
  gem.require_paths = %w[lib]
  gem.files         = %w[LICENSE README.md] +
                      Dir.glob('lib/**/*.rb') +
                      Dir.glob('bin/**/*') +
                      Dir.glob('views/**/*')
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }

  gem.add_dependency 'haml',          '~> 4.0'
  gem.add_dependency 'redcarpet',     '~> 2.2'
  gem.add_dependency 'albino',        '~> 1.3'
  gem.add_dependency 'sanitize',      '~> 2.0'
  gem.add_dependency 'activesupport', '~> 3.2'

  gem.add_development_dependency 'yard',         '~> 0.8.3'
  gem.add_development_dependency 'debugger-pry', '~> 0.1.1'
  gem.add_development_dependency 'rspec',        '~> 2.13.0'
  gem.add_development_dependency 'rake',         '~> 10.0.0'
  gem.add_development_dependency 'factory_girl', '~> 4.2.0'
  gem.add_development_dependency 'faker',        '~> 1.1.2'

end
