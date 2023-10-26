# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brreg_grunndata/version'

Gem::Specification.new do |spec|
  spec.name          = 'brreg_grunndata'
  spec.version       = BrregGrunndata::VERSION
  spec.authors       = ['Thorbjørn Hermansen']
  spec.email         = ['thhermansen@gmail.com']

  spec.summary       = %(Access BRREG's grunndata)
  spec.description   = %(Access BRREG's grunndata)
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'savon'
  spec.add_dependency 'dry-struct', '~> 1.0'
  spec.add_dependency 'dry-types', '~> 1.2'

  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.18.0'
  spec.add_development_dependency 'pry'
end
