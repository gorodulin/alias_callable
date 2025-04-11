# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story19

  class DoSomething
    def self.call(kwarg1:, kwarg2: "default_kwarg2")
      { passed_args: { kwarg1: kwarg1, kwarg2: kwarg2 } }
    end
  end

  class DummyKlass
    alias_callable :method_with_autofill_for_kwarg2, DoSomething, auto_fill: [:kwarg1, :kwarg2]
    alias_callable :method_wo_autofill_for_kwarg2, DoSomething, auto_fill: [:kwarg1]

    def initialize
      @kwarg1 = "autofilled"
      @kwarg2 = "also_autofilled"
    end
  end

end
