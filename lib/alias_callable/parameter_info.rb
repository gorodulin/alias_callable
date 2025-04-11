# frozen_string_literal: true

module AliasCallable

  ParameterInfo = Struct.new(:keywords, :positionals, :rest, :keyrest) do

    def initialize
      super([], [], false, false)
    end

    alias_method :rest?, :rest
    alias_method :keyrest?, :keyrest

  end

end
