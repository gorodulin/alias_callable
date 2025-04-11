# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story16

  class Callable1
    def self.call(kwarg1:, kwarg2:, kwarg3:)
      { passed_args: { kwarg1: kwarg1, kwarg2: kwarg2, kwarg3: kwarg3 } }
    end
  end

  class Callable2
    def self.call(kwarg1: "kwarg1_default")
      { passed_args: { kwarg1: kwarg1 } }
    end
  end

  class DummyKlassWithKwarg3NotAutofillable
    alias_callable :callable_1, Callable1, auto_fill: [:kwarg1, :kwarg2, :kwarg3]

    def initialize
      @kwarg1 = "expected1"
      @kwarg2 = "unexpected2"
    end

    def kwarg2
      "expected2"
    end
  end

  class DummyKlassWithoutAutofillSources
    alias_callable :callable_1, Callable1, auto_fill: [:kwarg1, :kwarg2, :kwarg3]
    alias_callable :callable_2, Callable2, auto_fill: [:kwarg1]
  end

end
