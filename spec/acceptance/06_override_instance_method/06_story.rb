# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story06

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
    alias_callable :do_something, Callable1
    alias_callable :do_something, Callable2 # This will override the previous alias
  end

end
