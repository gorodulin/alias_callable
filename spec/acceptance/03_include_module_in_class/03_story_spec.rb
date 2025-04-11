# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story03" do
  let(:ns) { Story03 }
  let(:klass) { ns::DummyKlass }

  before { load File.join(__dir__, "03_story.rb") }

  describe "Story03::DummyKlass" do
    subject { klass }
    it_behaves_like "has instance methods", [:do_something, :do_something_else]
  end

  describe "Story03::IncludableModule" do
    subject(:includable_module) { ns::IncludableModule }

    it "has instance methods" do
      expect(includable_module.instance_methods).to include(:do_something)
    end
  end

  describe "instance of class with IncludableModule included" do
    subject(:instance) { klass.new }

    it "has instance methods" do
      expect(instance).to respond_to(:do_something)
      expect(instance).to respond_to(:do_something_else)
    end

    describe "#do_something instance method" do
      subject(:method_call) { instance.do_something }

      it "returns the result from Callable1" do
        expect(method_call).to eq(:result_from_callable_1)
        expect(klass.aliased_callable(:do_something)).to eq(ns::Callable1)
      end
    end

    describe "#do_something_else instance method" do
      subject(:method_call) { instance.do_something_else }

      it "returns the result from Callable2" do
        expect(method_call).to eq(:result_from_callable_2)
        expect(klass.aliased_callable(:do_something_else)).to eq(ns::Callable2)
      end
    end

  end

end
