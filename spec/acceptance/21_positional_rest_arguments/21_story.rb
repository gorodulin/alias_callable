# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story21

  class Callable1
    def self.call(*rest)
      { passed_args: { rest: rest } }
    end
  end

  class Callable2
    def self.call(pos1, pos2, *rest)
      { passed_args: { pos1: pos1, pos2: pos2, rest: rest } }
    end
  end

  class Callable3
    def self.call(*rest, kwarg1:)
      { passed_args: { rest: rest, kwarg1: kwarg1 } }
    end
  end

  class Callable4
    def self.call(*rest, **kwrest)
      { passed_args: { rest: rest, kwrest: kwrest } }
    end
  end

  class DummyKlass
    alias_callable :callable_1, Callable1
    alias_callable :callable_2, Callable2
    alias_callable :callable_3, Callable3
    alias_callable :callable_4, Callable4
  end

end
