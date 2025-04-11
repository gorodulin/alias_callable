# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story04

  class DoSomething
    def self.call
      :do_something_call
    end
  end

  module ExtendableModule
    alias_callable :do_something, DoSomething
    alias_callable :do_something_else, DoSomething
  end

  class DummyKlass
    extend ExtendableModule
  end

end
