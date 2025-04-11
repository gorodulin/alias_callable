# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story08

  class Callable1
    def self.call
      :result_from_callable_1
    end
  end

  class Callable2
    def self.call
      :result_from_callable_2
    end
  end

  class DummyKlass
    private alias_callable :private_action, Callable1
    protected alias_callable :protected_action, Callable1

    class << self
      private alias_callable :private_action, Callable2 # Different from the instance method
      protected alias_callable :protected_action, Callable2 # Different from the instance method
    end
  end

end
