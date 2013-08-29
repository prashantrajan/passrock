# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'passrock/version'

Gem::Specification.new do |spec|
  spec.name          = 'passrock'
  spec.version       = Passrock::VERSION
  spec.authors       = ['Bitium Inc']
  spec.email         = ['devops@bitium.com']
  spec.description   = %q{Client library for Passrock Binary Database}
  spec.summary       = %q{Ruby client library to access a Passrock (Passrock.com) binary database }
  spec.homepage      = 'https://github.com/bitium/passrock'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'bcrypt-ruby'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'rails', '>= 3.2'
  spec.add_development_dependency 'dotenv', '~> 0.8'
end
