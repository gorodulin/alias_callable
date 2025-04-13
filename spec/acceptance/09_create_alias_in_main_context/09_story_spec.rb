# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story09" do

  describe "#alias_callable" do
    context "when used in the main context" do
      it "raises error and does not define a new method" do
        expect(AliasCallable.enabled_globally?).to be_truthy # ensure the feature is enabled
        expect do
          load File.join(__dir__, "09_story.rb")
        end.to raise_error(NoMethodError, /undefined method.*alias_callable.*for main/)
        result = eval("respond_to?(:do_something, true)", TOPLEVEL_BINDING) # rubocop:disable Style/EvalWithLocation
        expect(result).to be false
      end
    end
  end
end
