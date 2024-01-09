# frozen_string_literal: true

require_relative "lib/prius/version"

Gem::Specification.new do |spec|
  spec.name          = "prius"
  spec.version       = Prius::VERSION
  spec.authors       = ["GoCardless Engineering"]
  spec.email         = ["engineering@gocardless.com"]
  spec.summary       = "Environmentally-friendly config. Validate and enforce the presence " \
                       "and correct types of environment variables."
  spec.description = <<~MSG.strip.tr("\n", " ")
    Prius is a powerful and versatile gem designed to simplify the management of environment variables
    in your application. With Prius, you can guarantee that your environment variables are not only
    present but also valid, ensuring a smoother and more reliable app experience.
  MSG
  spec.homepage      = "https://github.com/gocardless/prius"
  spec.license       = "MIT"
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.0"
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/
                                                             .git .circleci appveyor])
    end
  end

  spec.metadata["rubygems_mfa_required"] = "true"
end
