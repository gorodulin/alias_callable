# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story15" do
  let(:ns) { Story15 }
  let(:aliased_callable) { ns::DoSomething }

  before { load File.join(__dir__, "15_story.rb") }

  describe "class with both instance vars and reader methods that have the same name as keyword arguments" do
    subject(:instance) { ns::DummyKlassWithBothInstanceVarsAndReaderMethods.new }

    context "when keyword arguments are not provided" do
      it "automatically pulls values from instance variables and methods, preferring methods" do
        result = instance.do_something
        expect(result[:passed_args])
          .to eq({ kwarg1: "kwarg1_from_instance_var", kwarg2: "kwarg2_from_reader", kwarg3: "kwarg3_from_reader" })
      end
    end

    context "when keyword arguments are provided" do
      it "uses the provided keyword arguments" do
        result = instance.do_something(kwarg1: "provided_kwarg1", kwarg2: "provided_kwarg2")
        expect(result[:passed_args])
          .to eq({ kwarg1: "provided_kwarg1", kwarg2: "provided_kwarg2", kwarg3: "kwarg3_from_reader" })
      end
    end
  end

end
