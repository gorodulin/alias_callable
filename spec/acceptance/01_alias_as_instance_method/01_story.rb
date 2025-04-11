# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story01

  class DoSomething
    def self.call
      :do_something_call
    end
  end

  class DummyKlass
    alias_callable :do_something, DoSomething
    alias_callable :do_something_else, DoSomething
  end

end
