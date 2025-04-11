# frozen_string_literal: true

module AliasCallable

  autoload :BuildAliasMethod,             "alias_callable/build_alias_method"
  autoload :ClassMethods,                 "alias_callable/class_methods"
  autoload :ExtractCallableParameters,    "alias_callable/extract_callable_parameters"
  autoload :ParameterInfo,                "alias_callable/parameter_info"
  autoload :UNDEFINED,                    "alias_callable/undefined"
  autoload :UnknownCallableError,         "alias_callable/unknown_callable_error"
  autoload :VERSION,                      "alias_callable/version"

  def self.enable_globally
    ::Module.include(::AliasCallable::ClassMethods) unless enabled_globally?
  end

  def self.enabled_globally?
    ::Module.included_modules.include?(::AliasCallable::ClassMethods)
  end

end
