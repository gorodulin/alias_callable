# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story04" do
  let(:ns) { Story04 }
  let(:aliased_callable) { ns::DoSomething }

  before { load File.join(__dir__, "04_story.rb") }

  describe "Story04::DummyKlass" do
    subject(:klass) { ns::DummyKlass }
    it_behaves_like "has class methods", [:do_something, :do_something_else]
  end

  describe "class methods" do
    let(:klass) { ns::DummyKlass }
    before { expect(aliased_callable).to receive(:call).and_call_original }

    describe "#do_something class method" do
      subject(:method_call) { klass.send(:do_something) }

      it "returns the result from the callable" do
        expect(method_call).to eq(:do_something_call)
      end
    end

    describe "#do_something_else class method" do
      subject(:method_call) { klass.send(:do_something_else) }

      it "returns the result from the callable" do
        expect(method_call).to eq(:do_something_call)
      end
    end
  end

end
