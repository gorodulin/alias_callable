# frozen_string_literal: true

require_relative "lib/alias_callable/version"

Gem::Specification.new do |spec|
  spec.name         = "alias_callable"
  spec.version      = AliasCallable::VERSION
  spec.authors      = ["Vladimir Gorodulin"]
  spec.email        = ["ru.hostmaster@gmail.com"]
  spec.description  = "Bring callable classes to your code as methods."
  spec.summary      = "Call Service Objects with ease. Include them to your classes as methods!"
  spec.homepage     = "https://github.com/gorodulin/alias_callable"
  spec.license      = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.3")

  spec.metadata = {
    "changelog_uri"   => "https://github.com/gorodulin/alias_callable/blob/main/CHANGELOG.md",
    "homepage_uri"    => spec.homepage,
    "source_code_uri" => "https://github.com/gorodulin/alias_callable",
  }

  spec.files = Dir["lib/**/*.{rb,erb}"] + %w[LICENSE README.md CHANGELOG.md]

  spec.require_paths = ["lib"]
end
