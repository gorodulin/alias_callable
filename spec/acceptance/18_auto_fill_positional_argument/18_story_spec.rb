# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story18" do
  subject(:load_story) { load File.join(__dir__, "18_story.rb") }

  describe "during loading" do
    context "when enable auto_fill for a positional argument" do
      it "raises ArgumentError" do
        expect { load_story }.to raise_error(ArgumentError, /Unsupported auto_fill arguments: posarg/)
      end
    end
  end

end
