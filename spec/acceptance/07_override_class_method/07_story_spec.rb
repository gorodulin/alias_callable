# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story07" do
  let(:ns) { Story07 }

  before { load File.join(__dir__, "07_story.rb") }

  describe "Story07::DummyKlass" do
    subject(:klass) { ns::DummyKlass }
    it_behaves_like "has class methods", [:do_something]

    describe "class methods" do
      describe "method with overridden alias_callable" do
        subject(:method_call) { klass.do_something }

        it "returns the result from the second callable (overridden)" do
          expect(method_call).to eq(:result_from_callable_2)
        end
      end

      describe "#aliased_callable" do
        context "when called on the class" do
          subject(:method_call) { klass.aliased_callable(:do_something) }

          it "raises an error" do
            expect { method_call }.to raise_error(::AliasCallable::UnknownCallableError, /`do_something`/)
          end
        end
      end
    end

    describe "singleton class methods" do
      describe "#aliased_callable" do
        context "when valid method name provided" do
          subject(:method_call) { klass.singleton_class.aliased_callable(:do_something) }

          it "returns the overridden callable" do
            expect(method_call).to eq(ns::Callable2)
          end
        end

        context "when invalid method name provided" do
          subject(:method_call) { klass.singleton_class.aliased_callable(:invalid_method) }

          it "raises an error" do
            expect { method_call }.to raise_error(::AliasCallable::UnknownCallableError, /`invalid_method`/)
          end
        end
      end
    end

    describe "instance methods" do
      describe "#aliased_callable called on the instance" do
        subject(:method_call) { klass.new.aliased_callable(:do_something) }

        it "raises an error" do
          expect { method_call }.to raise_error(NoMethodError)
        end
      end
    end
  end
end
