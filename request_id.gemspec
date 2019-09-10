# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'request_id/version'

Gem::Specification.new do |spec|
  spec.name          = 'request_id'
  spec.version       = RequestId::VERSION
  spec.authors       = ['Eric J. Holmes']
  spec.email         = ['eric@ejholmes.net']
  spec.description   = 'Classes for tracking request id'
  spec.summary       = 'Classes for tracking request id'
  spec.homepage      = 'https://github.com/remind101/request_id'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'faraday'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
