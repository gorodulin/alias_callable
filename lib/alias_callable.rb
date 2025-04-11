# frozen_string_literal: true

module AliasCallable
  UnknownCallableError = Class.new(StandardError)

  unless const_defined?(:UNDEFINED)
    UNDEFINED = Class.new do
      def inspect; "UNDEFINED"; end # rubocop:disable Style/SingleLineMethods
      alias_method :to_s, :inspect
    end.new
  end

  unless const_defined?(:ParameterInfo)
    ParameterInfo = Struct.new(:keywords, :positionals, :rest, :keyrest) do
      def initialize
        super([], [], false, false)
      end
      alias_method :rest?, :rest
      alias_method :keyrest?, :keyrest
    end
  end

  def self.enable_globally
    unless ::Module.included_modules.include?(::AliasCallable::ClassMethods)
      ::Module.include(::AliasCallable::ClassMethods)
      true
    end
    false
  end

  module ClassMethods
    def alias_callable(alias_name, callable, auto_fill: [])
      method_code = ::AliasCallable::BuildAliasMethod
        .call(alias_name: alias_name, callable: callable, auto_fill: auto_fill)
      # Define the delegator method with smart argument forwarding
      class_eval(method_code)
      # Define the raw delegator method and make it private
      # This is the method that will be called by the alias
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def _callable__#{alias_name}       # def _callable__do_something
          #{callable}                      #   ::DoSomething
        end                                # end
        private :_callable__#{alias_name}  # private :_callable__do_something
      RUBY
      alias_name
    end

    def aliased_callable(alias_name)
      get_attached_object = ->(sc) do
        if sc.respond_to?(:attached_object)
          sc.attached_object
        else
          ::ObjectSpace.each_object(Object).find { |o| o.is_a?(Module) && o.singleton_class == sc }
        end
      end
      target = self.singleton_class? ? get_attached_object.call(self) : self.allocate
      helper_name = :"_callable__#{alias_name}"
      unless target.private_methods.include?(helper_name)
        raise ::AliasCallable::UnknownCallableError, "No callable registered as `#{alias_name}` in #{self}."
      end
      target.send(helper_name)
    end
  end

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
      return false if @callable.is_a?(Module) # not instantiable, so nowhere to forward
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
