# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Story13" do
  let(:ns) { Story13 }
  let(:aliased_callable) { ns::DoSomething }

  before { load File.join(__dir__, "13_story.rb") }

  describe "auto_fill callable with keyword arguments" do

    describe "context has instance vars that have the same name as keyword arguments" do
      subject(:instance) { ns::DummyKlassWithInstanceVars.new }

      it "automatically passes values from instance variables" do
        result = instance.do_something
        expect(result[:passed_args]).to eq({ kwarg1: "expected1", kwarg2: "expected2", kwarg3: "expected3" })
      end
    end

  end
end
