# frozen_string_literal: true

require File.join(__dir__, *%w[.. config boot.rb])

if Gem::Specification.find_all_by_name("simplecov").any? && !ENV["GITHUB_ACTIONS"]
  require "simplecov"
  SimpleCov.start
end

Dir[File.join(__dir__, *%w[support ** *.rb])].sort.each { |file| require file }

# Require shared examples
Dir[File.join(__dir__, "support/shared_examples/**/*.rb")].sort.each { |file| require file }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
