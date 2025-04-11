# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story16" do
  let(:ns) { Story16 }
  let(:aliased_callable) { ns::Callable1 }

  before { load File.join(__dir__, "16_story.rb") }

  describe "class with non-autofillable argument :kwarg3" do
    subject(:instance) { ns::DummyKlassWithKwarg3NotAutofillable.new }

    context "when kwarg3 is not provided" do
      it "raises ArgumentError when trying to call the method" do
        expect { instance.callable_1 }.to raise_error(ArgumentError, /missing keyword: :kwarg3/)
      end
    end
    context "when kwarg3 is provided" do
      it "does not raise ArgumentError" do
        result = instance.callable_1(kwarg3: "provided_value")
        expect(result[:passed_args]).to eq({ kwarg1: "expected1", kwarg2: "expected2", kwarg3: "provided_value" })
      end
    end
  end

  describe "class without sources for autofilling keyword arguments" do
    subject(:instance) { ns::DummyKlassWithoutAutofillSources.new }

    it "raises ArgumentError when trying to call the method" do
      expect { instance.callable_1 }.to raise_error(ArgumentError, /missing keyword/)
    end

    it "raises ArgumentError when trying to call the method" do
      expect(instance.callable_2[:passed_args]).to eq({ kwarg1: "kwarg1_default" })
    end
  end

end
