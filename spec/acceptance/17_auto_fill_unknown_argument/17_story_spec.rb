# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story17" do
  subject(:load_story) { load File.join(__dir__, "17_story.rb") }

  describe "during loading" do
    context "when enable auto_fill for an unsupported keyword argument" do
      it "raises ArgumentError" do
        expect { load_story }.to raise_error(ArgumentError, /Unsupported auto_fill arguments: unsupported/)
      end
    end
  end

end
