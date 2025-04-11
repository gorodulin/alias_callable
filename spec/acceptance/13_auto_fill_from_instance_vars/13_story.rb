# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story13

  class DoSomething
    def self.call(kwarg1:, kwarg2:, kwarg3:)
      { passed_args: { kwarg1: kwarg1, kwarg2: kwarg2, kwarg3: kwarg3 } }
    end
  end

  class DummyKlassWithInstanceVars
    alias_callable :do_something, DoSomething, auto_fill: [:kwarg1, :kwarg2, :kwarg3]

    def initialize
      @kwarg1 = "expected1"
      @kwarg2 = "expected2"
      @kwarg3 = "expected3"
    end
  end

end
