# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'samsao/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name = 'danger-samsao'
  spec.version = Samsao::VERSION
  spec.authors = ['Samsao Development Inc.']
  spec.email = ['mvachon@samsao.co']
  spec.description = 'Danger plugin for Samsao PR guidelines.'
  spec.summary = 'A longer description of danger-samsao.'
  spec.homepage = 'https://github.com/samsao/danger-samsao'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.0'

  spec.add_runtime_dependency 'danger-plugin-api', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-rubocop', '~> 1.2'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'pry', '~> 0.11.0.pre2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.41'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'yard', '~> 0.8'
end
