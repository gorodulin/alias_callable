# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story05" do
  let(:ns) { Story05 }
  let(:callable_1) { ns::Callable1 }
  let(:callable_2) { ns::Callable2 }

  before { load File.join(__dir__, "05_story.rb") }

  describe "Story05::DummyKlass" do
    subject(:klass) { ns::DummyKlass }
    it_behaves_like "has instance methods", [:do_something]
    it_behaves_like "has class methods", [:do_something]

    describe "class methods" do
      describe "method from module we extended the class with" do
        subject(:method_call) { klass.do_something }

        it "returns the result from the callable" do
          expect(method_call).to eq(:result_from_callable_2)
        end
      end

      describe "#aliased_callable called on CLASS" do
        context "when valid method name provided" do
          subject(:method_call) { klass.aliased_callable(:do_something) }
          it "returns the aliased callable for INSTANCE" do
            expect(method_call).to eq(ns::Callable1)
          end
        end
        context "when invalid method name provided" do
          subject(:method_call) { klass.aliased_callable(:invalid_method) }

          it "raises an error" do
            expect { method_call }.to raise_error(::AliasCallable::UnknownCallableError, /`invalid_method`/)
          end
        end
      end
    end

    describe "instance methods" do
      describe "method from included module" do
        subject(:method_call) { klass.new.do_something }

        it "returns the result from the callable" do
          expect(method_call).to eq(:result_from_callable_1)
        end
      end
    end

    describe "singleton class methods" do
      describe "#aliased_callable called on SINGLETON_CLASS" do
        context "when valid method name provided" do
          subject(:method_call) { klass.singleton_class.aliased_callable(:do_something) }
          it "returns the aliased callable for CLASS" do
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

  end
end
