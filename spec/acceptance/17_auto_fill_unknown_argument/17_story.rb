# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story17

  class DoSomething
    def self.call(known:)
      { passed_args: { known: known } }
    end
  end

  class DummyKlass
    alias_callable :do_something, DoSomething, auto_fill: [:known, :unsupported]
    # This is a test to see if the unsupported is not passed to do_something method

    def initialize
      @known = "expected"
      @unsupported = "from_instance_var"
    end

    def unsupported
      "from_reader"
    end
  end

end
