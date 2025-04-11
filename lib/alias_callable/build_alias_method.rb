# frozen_string_literal: true

module AliasCallable

  class BuildAliasMethod
    def self.call(**kwargs)
      new(**kwargs).call
    end

    def initialize(alias_name:, callable:, auto_fill: [])
      @alias_name = alias_name
      @callable = callable
      @auto_fill = auto_fill
    end

    def call
      ensure_auto_fill_validity! # Ensure that the auto_fill arguments are valid
      signature = generate_method_signature # Generate method signature with proper parameters
      kwargs_logic = generate_kwargs_logic # Generate code to handle keyword arguments with auto-fetching
      call_expression = generate_call_expression # Generate the final method call with all arguments

      <<-RUBY
        def #{alias_name}(#{signature})
          kwargs = {}
          #{kwargs_logic}
          #{call_expression}
        end
      RUBY
    end

    private

    attr_reader :alias_name, :callable, :auto_fill

    def params
      @params ||= ::AliasCallable::ExtractCallableParameters.new(callable).call
    end

    def ensure_auto_fill_validity!
      unsupported = auto_fill - params.keywords
      if unsupported.any? # rubocop:disable Style/GuardClause
        raise ArgumentError, "Unsupported auto_fill arguments: #{unsupported.join(', ')}"
      end
    end

    def generate_method_signature
      parts = []

      # Add positional parameters if any
      if params.positionals.any? || params.rest?
        parts << "*args"
      end

      if auto_fill.any?
        parts << auto_fill.map do |kw|
          "#{kw}: ::AliasCallable::UNDEFINED"
        end.join(", ")
      end

      # Always add keyrest capture to support methods with **kwargs
      # Even if the callable doesn't have keyrest, this allows for more flexible method calls
      parts << "**extra_kwargs"

      # Always include block parameter to support both explicit &block and block_given?
      parts << "&block"

      parts.join(", ")
    end

    def generate_kwargs_logic
      logic = []

      auto_fill.each do |kw|
        logic << <<-RUBY
          if #{kw} != ::AliasCallable::UNDEFINED
            kwargs[:#{kw}] = #{kw}
          elsif respond_to?(:#{kw}, true)
            kwargs[:#{kw}] = send(:#{kw})
          elsif instance_variable_defined?("@#{kw}")
            kwargs[:#{kw}] = instance_variable_get("@#{kw}")
          end
        RUBY
      end

      # Handle extra_kwargs (always include them in kwargs)
      # Merge any additional keyword arguments
      logic << <<-RUBY
        kwargs.merge!(extra_kwargs) unless extra_kwargs.empty?
      RUBY

      logic.join("\n")
    end

    def generate_call_expression
      parts = []

      # Add positional args if needed
      if params.positionals.any? || params.rest?
        parts << "*args"
      end

      # Add keyword args
      parts << "**kwargs"

      # Always pass the block, regardless of whether the callable has an explicit block parameter
      # This ensures support for callables that use block_given? internally
      parts << "&block"

      "_callable__#{alias_name}.call(#{parts.join(', ')})"
    end
  end

end
