# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story22" do
  let(:ns) { Story22 }
  subject(:instance) { ns::DummyKlass.new }

  before { load File.join(__dir__, "22_story.rb") }

  describe "EXPLICIT &block support" do
    describe "callable with *rest positional arguments supported" do
      context "when alias method is called with positional args and a block" do
        it "passes them to the callable and executes the block with the result" do
          result = instance.callable_1(1, 2, 3) do
            { additional: "data" }
          end

          expect(result).to eq({
                                 passed_args: { rest: [1, 2, 3], extra_args: { additional: "data" } },
                               })
        end
      end

      context "when alias method is called with only a block" do
        it "passes empty rest array to the callable and executes the block" do
          result = instance.callable_1 do
            { additional: "data" }
          end

          expect(result).to eq({
                                 passed_args: { rest: [], extra_args: { additional: "data" } },
                               })
        end
      end

      context "when alias method is called with no args and no block" do
        it "passes empty rest array to the callable and no extra_args" do
          result = instance.callable_1

          expect(result).to eq({
                                 passed_args: { rest: [], extra_args: nil },
                               })
        end
      end
    end
  end

  describe "IMPLICIT block support" do
    describe "callable with **kwrest arguments are supported" do
      context "when alias method is called with keyword args and a block" do
        it "passes them to the callable and executes the block" do
          result = instance.callable_2(key1: "value1", key2: "value2") do
            { additional: "data" }
          end

          expect(result).to eq({
                                 passed_args: { kwrest: { key1: "value1", key2: "value2" },
                                                extra_args: { additional: "data" } },
                               })
        end
      end

      context "when alias method is called with only a block" do
        it "passes empty hash to the callable and executes the block" do
          result = instance.callable_2 do
            { additional: "data" }
          end

          expect(result).to eq({
                                 passed_args: { kwrest: {}, extra_args: { additional: "data" } },
                               })
        end
      end

      context "when alias method is called with no args and no block" do
        it "passes empty hash to the callable and no extra_args" do
          result = instance.callable_2

          expect(result).to eq({
                                 passed_args: { kwrest: {}, extra_args: nil },
                               })
        end
      end
    end
  end
end
