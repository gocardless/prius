# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prius/version'

Gem::Specification.new do |spec|
  spec.name          = "prius"
  spec.version       = Prius::VERSION
  spec.authors       = ["Harry Marr"]
  spec.email         = ["engineering@gocardless.com"]
  spec.description   = %q{Environmentally-friendly config}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/gocardless/prius"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.1"
end
