# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story05

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
  end

  module ExtendableModule
    alias_callable :do_something, Callable2
  end

  class DummyKlass
    include IncludableModule # brings #do_something to the instance level
    extend ExtendableModule  # brings #do_something to the class level (returns a different callable)
  end

end
