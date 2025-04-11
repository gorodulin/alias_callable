# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story08" do
  let(:ns) { Story08 }

  before { load File.join(__dir__, "08_story.rb") }

  describe "Story08::DummyKlass" do
    subject(:klass) { ns::DummyKlass }

    it_behaves_like "has class methods", [:private_action, :protected_action]
    it_behaves_like "has instance methods", [:private_action, :protected_action]

    describe "aliased instance methods" do
      describe "#private_action" do
        it "aliases callable" do
          expect(klass.new.send(:private_action)).to eq(:result_from_callable_1)
          expect { klass.new.private_action }.to raise_error(/private method/)
        end
      end
      describe "#protected_action" do
        it "aliases callable" do
          expect(klass.new.send(:protected_action)).to eq(:result_from_callable_1)
          expect { klass.new.protected_action }.to raise_error(/protected method/)
        end
      end
    end

    describe "aliased class methods" do
      describe "#private_action" do
        it "aliases callable" do
          expect(klass.send(:private_action)).to eq(:result_from_callable_2)
        end
      end

      describe "#protected_action" do
        it "aliases callable" do
          expect(klass.send(:protected_action)).to eq(:result_from_callable_2)
        end
      end
    end

    describe "#aliased_callable" do
      context "when called on the class" do
        it "returns the callable for the instance-level alias" do
          expect(klass.aliased_callable(:private_action)).to eq(ns::Callable1)
        end
      end
      context "when called on the singleton class" do
        it "returns the callable for the class-level alias" do
          expect(klass.singleton_class.aliased_callable(:private_action)).to eq(ns::Callable2)
        end
      end
      context "when called on the instance" do
        it "raises an error" do
          expect { klass.new.aliased_callable(:private_action) }.to raise_error(NoMethodError)
        end
      end
    end

  end
end
