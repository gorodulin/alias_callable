# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story03

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

  module IncludableModule
    alias_callable :do_something, Callable1
    alias_callable :do_something_else, Callable2
  end

  class DummyKlass
    include IncludableModule
  end

end
