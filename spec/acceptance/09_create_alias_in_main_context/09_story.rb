# frozen_string_literal: true

module Story09
  class DoSomething
    def self.call
      puts "Doing something"
    end
  end
end

alias_callable :do_something, Story09::DoSomething # should raise error in main context
