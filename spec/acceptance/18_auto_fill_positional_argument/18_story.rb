# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story18

  class DoSomething
    def self.call(posarg, kwarg:)
      { passed_args: { posarg: posarg, kwarg: kwarg } }
    end
  end

  class DummyKlass
    alias_callable :do_something, DoSomething, auto_fill: [:posarg, :kwarg]

    def initialize
      @posarg = nil
      @kwarg = nil
    end
  end

end
