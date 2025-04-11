# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story14" do
  let(:ns) { Story14 }
  let(:aliased_callable) { ns::DoSomething }

  before { load File.join(__dir__, "14_story.rb") }

  describe "Story14" do

    describe "class with reader methods that have the same name as keyword arguments" do
      subject(:instance) { ns::DummyKlassWithReaderMethods.new }

      it "automatically pulls values from reader methods" do
        result = instance.do_something
        expect(result[:passed_args]).to eq({ kwarg1: "expected1", kwarg2: "expected2", kwarg3: "expected3" })
      end
    end

  end
end
