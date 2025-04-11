# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story19" do
  let(:ns) { Story19 }
  let(:aliased_callable) { ns::DoSomething }

  before { load File.join(__dir__, "19_story.rb") }

  context "when a keyword argument has a default value" do
    subject(:instance) { ns::DummyKlass.new }

    describe "method with auto-fill" do
      it "automatically overwrites default value" do
        result = instance.method_with_autofill_for_kwarg2
        expect(result[:passed_args]).to eq({ kwarg1: "autofilled", kwarg2: "also_autofilled" })
      end
    end

    describe "method without auto-fill" do
      it "automatically overwrites default value" do
        result = instance.method_wo_autofill_for_kwarg2
        expect(result[:passed_args]).to eq({ kwarg1: "autofilled", kwarg2: "default_kwarg2" })
      end
    end

  end
end
