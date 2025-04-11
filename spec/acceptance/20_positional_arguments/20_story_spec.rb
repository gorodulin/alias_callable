# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story20" do
  let(:ns) { Story20 }
  subject(:instance) { ns::DummyKlass.new }

  before { load File.join(__dir__, "20_story.rb") }

  context "when the callable supports positional arguments" do
    context "when no arguments are passed" do
      it "raises 'wrong number of arguments' error" do
        expect { instance.do_something }.to raise_error(ArgumentError, /wrong number of arguments \(given 0/)
      end
    end

    context "when not enough arguments are passed" do
      it "raises 'wrong number of arguments' error" do
        expect { instance.do_something(1) }.to raise_error(ArgumentError, /wrong number of arguments \(given 1/)
      end
    end

    context "when the minimal of arguments are passed" do
      it "returns the result from the callable" do
        expect(instance.do_something(1, 2)[:passed_args])
          .to eq({ pos1: 1, pos2: 2, pos3: "pos3_default", kwarg1: "kwarg1_default" })
      end
    end

    context "when all positional arguments are passed" do
      it "returns the result from the callable" do
        expect(instance.do_something(1, 2, 3)[:passed_args])
          .to eq({ pos1: 1, pos2: 2, pos3: 3, kwarg1: "kwarg1_default" })
      end
    end

    context "when too many arguments are passed" do
      it "raises 'wrong number of arguments' error" do
        expect do
          instance.do_something(1, 2, 3, 4)
        end.to raise_error(ArgumentError, /wrong number of arguments \(given 4/)
      end
    end

    context "when combined with keyword arguments" do
      it "returns the result from the callable" do
        expect(instance.do_something(1, 2, kwarg1: "kwarg1_from_kwarg")[:passed_args])
          .to eq({ pos1: 1, pos2: 2, pos3: "pos3_default", kwarg1: "kwarg1_from_kwarg" })
      end
    end
  end
end
