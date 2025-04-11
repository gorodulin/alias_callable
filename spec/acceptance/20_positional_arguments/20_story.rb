# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story20

  class DoSomething
    def self.call(pos1, pos2, pos3 = "pos3_default", kwarg1: "kwarg1_default")
      { passed_args: { pos1: pos1, pos2: pos2, pos3: pos3, kwarg1: kwarg1 } }
    end
  end

  class DummyKlass
    alias_callable :do_something, DoSomething
  end

end
