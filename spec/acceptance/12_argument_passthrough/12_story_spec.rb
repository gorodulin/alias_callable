# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story12" do
  let(:ns) { Story12 }
  subject(:instance) { ns::DummyKlass.new }

  before do
    if RUBY_VERSION >= "3.1"
      load File.join(__dir__, "ruby_3.1_and_above", "12_story.rb")
    else
      skip "Only runs on Ruby 3.1 and above (support for (...) pass-through)"
    end
  end

  context "when callable.call delegates arguments to instance via (...) pass-through" do
    describe "alias of callable" do
      context "when arguments are required but not passed" do
        it "raises ArgumentError" do
          expect { instance.callable_1 }.to raise_error(ArgumentError, /wrong number of arguments/)
        end
      end

      context "when arguments are passed" do
        it "passes them through" do
          expect(instance.callable_1(1, kw: 2)[:passed_args])
            .to eq({ pos: 1, kw: 2 })
        end
      end
    end
  end

end
