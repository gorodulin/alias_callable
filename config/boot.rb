# frozen_string_literal: true

# This file loads all needed libs and project files in right order.
# Load it first during initialization and in spec_helper.rb

ROOT_PATH = File.expand_path("..", __dir__)
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

# Set up gems listed in the Gemfile.
require "bundler/setup"
$LOAD_PATH.unshift "#{ROOT_PATH}/lib"

require "pry" if Gem::Specification.find_all_by_name("pry").any?

require "alias_callable"
AliasCallable.enable_globally
