# frozen_string_literal: true

module AliasCallable

  autoload :BuildAliasMethod,             "alias_callable/build_alias_method"
  autoload :ClassMethods,                 "alias_callable/class_methods"
  autoload :ExtractCallableParameters,    "alias_callable/extract_callable_parameters"
  autoload :ParameterInfo,                "alias_callable/parameter_info"
  autoload :UNDEFINED,                    "alias_callable/undefined"
  autoload :UnknownCallableError,         "alias_callable/unknown_callable_error"
  autoload :VERSION,                      "alias_callable/version"

  @backtrace_filtering_enabled = false

  def self.enable_globally
    ::Module.include(::AliasCallable::ClassMethods) unless enabled_globally?
  end

  def self.enabled_globally?
    ::Module.included_modules.include?(::AliasCallable::ClassMethods)
  end

  def self.enable_backtrace_filtering
    return if backtrace_filtering_enabled?

    ::Exception.class_eval do
      alias_method :original_backtrace, :backtrace

      def backtrace
        bt = original_backtrace
        bt&.grep_v(%r{/alias_callable/})
      end
    end

    @backtrace_filtering_enabled = true
  end

  def self.backtrace_filtering_enabled?
    @backtrace_filtering_enabled
  end

end
