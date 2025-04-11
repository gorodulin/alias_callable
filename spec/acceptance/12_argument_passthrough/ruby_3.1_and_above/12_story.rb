# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story12

  class Callable1
    def self.call(...) = new(...).call

    def initialize(pos, kw:)
      @pos = pos
      @kw = kw
    end

    def call
      { passed_args: { pos: @pos, kw: @kw } }
    end
  end

  class DummyKlass
    alias_callable :callable_1, Callable1
  end

end
