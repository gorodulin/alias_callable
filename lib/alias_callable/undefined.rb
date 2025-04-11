# frozen_string_literal: true

module AliasCallable

  UNDEFINED = Class.new do

    def inspect
      "UNDEFINED"
    end

    alias_method :to_s, :inspect

  end.new

end
