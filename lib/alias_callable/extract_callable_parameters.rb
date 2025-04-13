# frozen_string_literal: true

module AliasCallable

  # Extracts parameters from a callable object (class/module)
  class ExtractCallableParameters
    def initialize(callable)
      @callable = callable
    end

    # Main method to extract parameter information from the callable
    def call
      info = ParameterInfo.new

      target_method_parameters.each do |param_type, param_name|
        case param_type
        when :key, :keyreq
          info.keywords << param_name
        when :req, :opt
          info.positionals << param_name
        when :rest
          info.rest = true
        when :keyrest
          info.keyrest = true
        end
      end

      info
    end

    private

    # Determine which method's parameters we should extract
    def target_method_parameters
      if callable_responds_to_call? && !call_forwards_all_arguments?
        class_callable_parameters # Parameters of callable.call method
      elsif instance_initialize_parameters.any?
        instance_initialize_parameters # Parameters of callable.new method
      else
        instance_callable_parameters # Parameters of callable.new.call method
      end
    end

    def callable_responds_to_call?
      @callable.respond_to?(:call)
    end

    def call_forwards_all_arguments?
      return false if @callable.instance_of?(Module) # not instantiable, so nowhere to forward
      return false unless @callable.instance_methods.include?(:call)

      full_argument_forwarding_pattern?(class_callable_parameters)
    end

    def full_argument_forwarding_pattern?(parameters)
      # See NOTES.md on full forwarding parameter patterns.
      # Handles:
      # - explicit *args, **kwargs, &block style regardless of parameter names
      # - *args, &block with ruby2_keywords (which lacks visible :keyrest in Ruby 2.7-3.0)
      # - the ... syntax in both
      #   - Ruby 3.0 (which showed [[:rest, :*], [:block, :&]]) and
      #   - Ruby 3.1+ (which shows [[:rest, :*], [:keyrest, :**], [:block, :&]])

      # Skip methods with specific required, optional or keyword parameters
      return false if parameters.any? do |param|
        [:req, :opt, :key, :keyreq].include?(param[0])
      end

      # Extract the parameter types (ignoring names)
      param_types = parameters.map { |param| param[0] }

      # Check for the required pattern components
      has_rest = param_types.include?(:rest)
      has_block = param_types.include?(:block)

      # Consider keyrest optional because:
      # 1. Ruby 3.0's `...` syntax initially didn't show keyrest in parameters inspection
      # 2. Explicit `*args, &block` (without keyrest) can still forward all arguments
      # in certain Ruby versions with ruby2_keywords applied

      # Must have at minimum rest + block
      if has_rest && has_block
        # No other parameter types should exist beyond rest, keyrest, and block
        extra_params = param_types - [:rest, :keyrest, :block]
        return extra_params.empty?
      end

      false
    end

    def class_callable_parameters
      @callable.method(:call).parameters # TODO: memoize
    end

    def instance_initialize_parameters
      @callable.instance_method(:initialize).parameters # TODO: memoize
    rescue NameError
      []
    end

    def instance_callable_parameters
      instance = @callable.allocate rescue nil # rubocop:disable Style/RescueModifier
      instance&.method(:call)&.parameters || []
    end
  end

end
