# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story21" do
  let(:ns) { Story21 }
  subject(:instance) { ns::DummyKlass.new }

  before { load File.join(__dir__, "21_story.rb") }

  describe "callable supporting only positional rest arguments" do
    context "when alias method is called with positional args" do
      it "passes them to the callable" do
        expect(instance.callable_1(1, 2, 3, 4)[:passed_args])
          .to eq({ rest: [1, 2, 3, 4] })
      end
    end

    context "when alias method is called without positional args" do
      it "passes nothing to the callable" do
        expect(instance.callable_1[:passed_args])
          .to eq({ rest: [] })
      end
    end
  end

  describe "callable supporting positional arguments (including rest)" do
    context "when alias method is called with positional args" do
      it "passes them to the callable" do
        expect(instance.callable_2(1, 2, 3, 4)[:passed_args])
          .to eq({ pos1: 1, pos2: 2, rest: [3, 4] })
      end
    end
  end

  describe "callable supporting rest arguments and keyword arguments" do
    context "when alias method is called with positional args and required keyword arg" do
      it "passes them to the callable" do
        expect(instance.callable_3(1, 2, 3, kwarg1: "value")[:passed_args])
          .to eq({ rest: [1, 2, 3], kwarg1: "value" })
      end
    end

    context "when alias method is called with only required keyword arg" do
      it "passes empty rest array to the callable" do
        expect(instance.callable_3(kwarg1: "value")[:passed_args])
          .to eq({ rest: [], kwarg1: "value" })
      end
    end
  end

  describe "callable supporting rest arguments and keyword rest arguments" do
    context "when alias method is called with positional args and keyword args" do
      it "passes them to the callable" do
        expect(instance.callable_4(1, 2, 3, key1: "value1", key2: "value2")[:passed_args])
          .to eq({ rest: [1, 2, 3], kwrest: { key1: "value1", key2: "value2" } })
      end
    end

    context "when alias method is called with only positional args" do
      it "passes positional args and empty kwrest hash to the callable" do
        expect(instance.callable_4(1, 2, 3)[:passed_args])
          .to eq({ rest: [1, 2, 3], kwrest: {} })
      end
    end

    context "when alias method is called with only keyword args" do
      it "passes empty rest array and keyword args to the callable" do
        expect(instance.callable_4(key1: "value1", key2: "value2")[:passed_args])
          .to eq({ rest: [], kwrest: { key1: "value1", key2: "value2" } })
      end
    end

    context "when alias method is called with no args" do
      it "passes empty rest array and empty kwrest hash to the callable" do
        expect(instance.callable_4[:passed_args])
          .to eq({ rest: [], kwrest: {} })
      end
    end
  end

end
