# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story02" do
  let(:ns) { Story02 }
  let(:aliased_callable) { ns::DoSomething }

  before { load File.join(__dir__, "02_story.rb") }

  describe "Story02::DummyKlass class" do
    subject(:klass) { ns::DummyKlass }

    it_behaves_like "has class methods", [:do_something, :do_something_else]

    describe "class methods" do
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
end
