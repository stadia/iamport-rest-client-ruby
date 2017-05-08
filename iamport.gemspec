# coding: utf-8
require './lib/iamport/version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'iamport'
  spec.version       = Iamport::VERSION
  spec.authors       = ['Sell it']
  spec.email         = ['webdeveloper@withsellit.com']

  spec.summary       = 'Ruby gem for Iamport'
  spec.description   = 'Ruby gem for Iamport'
  spec.homepage      = 'https://github.com/stadia/iamport-rest-client-ruby'
  spec.license       = 'MIT'

  spec.files         = Dir["lib/**/*", "LICENSE.txt"]
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'minitest-reporters'

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
end