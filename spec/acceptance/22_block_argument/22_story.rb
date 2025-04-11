# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story22

  class Callable1
    def self.call(*rest, &block)
      extra_args = block.call if block_given?
      { passed_args: { rest: rest, extra_args: extra_args } }
    end
  end

  class Callable2
    def self.call(**kwrest)
      extra_args = yield if block_given?
      { passed_args: { kwrest: kwrest, extra_args: extra_args } }
    end
  end

  class DummyKlass
    alias_callable :callable_1, Callable1
    alias_callable :callable_2, Callable2
  end

end
