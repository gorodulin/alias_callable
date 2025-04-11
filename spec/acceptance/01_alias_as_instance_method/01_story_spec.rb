# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story01" do
  let(:ns) { Story01 }
  let(:service_object) { ns::DoSomething }

  before { load File.join(__dir__, "01_story.rb") }

  describe "Story01::DummyKlass class" do
    subject(:klass) { ns::DummyKlass }

    it_behaves_like "has instance methods", [:do_something, :do_something_else]

    describe "instance methods" do
      before { expect(service_object).to receive(:call).and_call_original }

      describe "#do_something instance method" do
        subject(:method_call) { klass.new.send(:do_something) }

        it "calls DoSomething#call (class method) under the hood" do
          expect(method_call).to eq(:do_something_call)
        end
      end

      describe "#do_something_else instance method" do
        subject(:method_call) { klass.new.send(:do_something_else) }

        it "calls DoSomething#call (class method) under the hood" do
          expect(method_call).to eq(:do_something_call)
        end
      end

    end
  end

end
