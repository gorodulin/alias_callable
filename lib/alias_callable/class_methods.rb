# frozen_string_literal: true

module AliasCallable

  module ClassMethods
    def alias_callable(alias_name, callable, auto_fill: [])
      method_code = ::AliasCallable::BuildAliasMethod
        .call(alias_name: alias_name, callable: callable, auto_fill: auto_fill)
      # Define the delegator method with smart argument forwarding
      class_eval(method_code)
      # Define the "raw" delegator method and make it private
      # This is the method that will be called by the delegator (alias) method
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def _callable__#{alias_name}       # def _callable__do_something
          #{callable}                      #   ::DoSomething
        end                                # end
        private :_callable__#{alias_name}  # private :_callable__do_something
      RUBY
      alias_name
    end

    def aliased_callable(alias_name)
      get_attached_object = lambda do |sc|
        if sc.respond_to?(:attached_object)
          sc.attached_object
        else # Ruby 3.2 and earlier support. Slow, but better than nothing :(
          ::ObjectSpace.each_object(Object).find { |o| o.is_a?(Module) && o.singleton_class == sc }
        end
      end
      target = self.singleton_class? ? get_attached_object.call(self) : self.allocate # rubocop:disable Style/RedundantSelf
      helper_name = :"_callable__#{alias_name}"
      unless target.private_methods.include?(helper_name)
        raise ::AliasCallable::UnknownCallableError, "No callable registered as `#{alias_name}` in #{self}."
      end
      target.send(helper_name)
    end
  end

end
