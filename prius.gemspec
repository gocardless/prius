# coding: utf-8
# frozen_string_literal: true

require "English"

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "prius/version"

Gem::Specification.new do |spec|
  spec.name          = "prius"
  spec.version       = Prius::VERSION
  spec.authors       = ["GoCardless Engineering"]
  spec.email         = ["engineering@gocardless.com"]
  spec.description   = "Environmentally-friendly config"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/gocardless/prius"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.6"

  spec.add_development_dependency "gc_ruboconfig", "~> 3.6.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rspec-github", "~> 2.3.1"
  spec.metadata["rubygems_mfa_required"] = "true"
end
