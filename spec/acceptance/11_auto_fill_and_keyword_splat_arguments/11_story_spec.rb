# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story11" do
  let(:ns) { Story11 }
  subject(:instance) { ns::DummyKlass.new }

  describe "callable with keyword argument splat AND a regular keyword argument" do

    context "with auto_fill for known keyword argument" do

      before do
        load File.join(__dir__, "11_story_1.rb")
      end

      let(:attributes) { { field_1: 1, field_2: 2 } }
      subject { instance.create_record(**attributes) }

      it "gets autofilled" do
        expect(subject).to eq({ field_1: 1, field_2: 2, logger: "LOGGER" })
      end
    end

    context "with auto_fill for unknown keyword argument" do

      it "raises error early, while loading" do
        expect do
          load File.join(__dir__, "11_story_2.rb")
        end.to raise_error(ArgumentError, /Unsupported auto_fill arguments: unknown/)
      end
    end

  end

end
