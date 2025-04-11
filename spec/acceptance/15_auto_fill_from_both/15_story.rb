# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story15

  class DoSomething
    def self.call(kwarg1:, kwarg2:, kwarg3:)
      { passed_args: { kwarg1: kwarg1, kwarg2: kwarg2, kwarg3: kwarg3 } }
    end
  end

  class DummyKlassWithBothInstanceVarsAndReaderMethods
    alias_callable :do_something, DoSomething, auto_fill: [:kwarg1, :kwarg2, :kwarg3]

    def initialize
      @kwarg1 = "kwarg1_from_instance_var"
      @kwarg2 = "kwarg2_from_instance_var"
    end

    def kwarg2
      "kwarg2_from_reader"
    end

    def kwarg3
      "kwarg3_from_reader"
    end
  end

end
