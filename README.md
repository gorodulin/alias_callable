# alias_callable Ruby gem

> **Keywords:** #alias #callable #ruby #gem #p20240728a #dependency #inclusion #service-object #pattern #metaprogramming #delegation

**Transform your service objects into clean, testable methods with dependency aliasing.**

[![Gem Version](https://img.shields.io/gem/v/alias_callable.svg)](https://rubygems.org/gems/alias_callable)
[![Ruby](https://img.shields.io/badge/ruby-3.0%2B-red.svg)](https://www.ruby-lang.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Quick Start

```ruby
class UserController
  # Like alias_method, but for callable service objects:
  alias_callable :fetch_user, ::FetchUserData
  alias_callable :send_notification, ::SendNotification
  
  def show_user(id)
    user = fetch_user(id)  # instead of FetchUserData.call(id)
    send_notification("User loaded", user[:name])
    user
  end
end
```

## Overview

The `alias_callable` gem introduces a powerful dependency aliasing pattern for Ruby applications. Instead of directly calling service objects (classes that encapsulate business logic) throughout your code, you can alias them as methods, creating cleaner, more testable, and more maintainable code.

The approach is designed to feel idiomatic and familiar to Ruby developers — just like Ruby's built-in `alias_method` creates method aliases, `alias_callable` creates method aliases for your callable service objects.

### Key Benefits

- **Loose Coupling**: Uses method aliases instead of direct class references throughout your code
- **Explicit Dependencies**: Makes all dependencies clearly visible at the top of each class
- **Simplified Testing**: Provides clean, easy-to-mock method interfaces for your tests
- **Readable Code**: Replaces long namespace paths with short, expressive method names
- **Transparent Context Passing**: Seamlessly passes selected instance variables as method arguments

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alias_callable'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install alias_callable
```

### Setup Options

You can either enable `alias_callable` globally for all classes:

```ruby
# In your application initialization
AliasCallable.enable_globally
```

or extend this feature on a per-class/module basis:

```ruby
class AnyClass
  extend ::AliasCallable::ClassMethods # <- this brings the alias_callable method explicitly

  alias_callable :do_something, ::DoSomething
  # ...
end
```

## Benefits

### Before alias_callable:

```ruby
class OrderController
  def process_order(params)
    # Dependencies scattered throughout the code
    user = ::DataLayers::FindUser.call(params[:user_id])
    order = ::OrderService::CreateOrder.call(user: user, items: params[:items])
    ::CommService::SendEmail.call(order: order, template: :order_confirmation, logger: logger)
    ::Warehouse::UpdateInventory.call(items: params[:items], action: :reserve)
    order
  end
end
```

### With alias_callable:

```ruby
class OrderController
  
  # All dependencies clearly visible at the top
  alias_callable :create_order, ::OrderService::CreateOrder
  alias_callable :find_user, ::DataLayers::FindUser
  alias_callable :send_email, ::CommService::SendEmail, auto_fill: [:logger]
  alias_callable :update_inventory, ::Warehouse::UpdateInventory
  
  def process_order(params)
    # Clean, readable method calls
    user = find_user(params[:user_id]) # instead of DataLayers::FindUser.call(...)
    order = create_order(user: user, items: params[:items])
    send_email(order: order, template: :order_confirmation)
    update_inventory(items: params[:items], action: :reserve)
    order
  end
end
```

## Advanced Usage

### Automatic context passing

You can automatically pass selected instance variables to your service objects as _keyword arguments_ by specifying their names. This is especially useful for handling cross-cutting concerns such as logging, sessions, connections, instrumentation, or credentials. Use this feature wisely, prefer explicitness over magic.

```ruby
class CreateOrder
  def self.call(logger:, **attributes)
    logger.info("Creating order with #{attributes}")
    # Order creation logic
    { id: rand(1000), **attributes }
  end
end

class Orders::ProcessOrder
  alias_callable :create_order, ::CreateOrder, auto_fill: [:logger] # <- NOTE THIS
  
  def initialize(items:, customer_id:, logger:)
    @items = items
    @customer_id = customer_id
    @logger = logger
  end
  
  def call
    # The logger instance variable is IMPLICITLY passed to CreateOrder:
    order = create_order(items:, customer_id:)
    puts "Order #{order[:id]} created successfully"
  end

  # ...
end

logger = Logger.new($stdout)

Orders::ProcessOrder.call(items: ["Book", "Pen"], customer_id: 456, logger:)
```

### Testing Made Easy

The gem provides `aliased_callable` method that returns the aliased callable, making testing much more maintainable than stubbing explicit class names.

**Key advantages over direct class stubbing:**

- **Refactoring resilience**: When you rename or move service classes, your tests don't need updates
- **Automatic test maintenance**: If you remove an alias from the class, related test stubs will fail, indicating redundant mocking
- **Clean mocking interface**: Mock through the same alias used in your code

```ruby
# Instead of stubbing the class directly:
# allow(::FetchUser).to receive(:call)  # Breaks when class is renamed/moved

# Stub through the alias:
RSpec.describe UserController do
  let(:controller) { UserController.new }
  
  describe '#show_user' do
    it 'fetches and displays user data' do
      # Mock the aliased callable - stays in sync with your code
      allow(described_class.aliased_callable(:fetch_user))
        .to receive(:call)
        .with(123)
        .and_return({ id: 123, name: "Test User" })
      
      allow(described_class.aliased_callable(:send_notification))
        .to receive(:call)
        .with("User loaded", "Test User")
      
      result = controller.show_user(123)
      
      expect(result[:name]).to eq("Test User")
    end
  end
end
```

Add this shared helper to your unit specs to get a shortcut:

```ruby
def callable(name)
  described_class.aliased_callable(name)
end
```

## Best Practices

- Order alias methods alphabetically.
- Use full class names prefixed with `::`. This will make it easier to find and replace dependencies when you rename classes and namespaces.
- Prefer using `auto_fill` only for passing auxiliary context (loggers, trackers, credentials, connections).

## Alternatives

### dry-auto_inject

The [dry-auto_inject](https://github.com/dry-rb/dry-auto_inject) gem provides a similar dependency injection pattern but with some key differences:

**Key Differences:**

- **Initialize Signature**: `alias_callable` does not require changes to your `initialize` method signature, while `dry-auto_inject` modifies class constructors
- **Dependency Type**: `alias_callable` brings hardcoded dependencies (direct class references), not dependency _injection_ like `dry-auto_inject`
- **Configuration**: 
  - `dry-auto_inject` requires listing aliases separately from the actual objects/classes (typically in a container file)
  - `alias_callable` defines aliases inline with direct class references

**Example comparison:**

```ruby
# dry-auto_inject approach
class OrderController
  include Import["services.create_order", "services.find_user"]
  
  def initialize(**deps)
    super
  end
end

# alias_callable approach  
class OrderController
  alias_callable :create_order, ::OrderService::CreateOrder
  alias_callable :find_user, ::Services::FindUser
  
  # No initialize changes needed
end
```

Choose `dry-auto_inject` if you need true dependency _injection_ with container-managed dependencies. Choose `alias_callable` if you want simpler hardcoded dependencies without constructor modifications.

## Load-Time Errors for Missing Classes

If a referenced class doesn't exist, you'll get an error _at load time_:

```ruby
class MyClass
  alias_callable :missing_service, ::NonExistentClass
end
# => NameError: uninitialized constant NonExistentClass
```

## Extra Feature: Backtrace Filtering

Clean up your backtraces by filtering out alias_callable internals:

```ruby
AliasCallable.enable_backtrace_filtering
```

Filtering backtraces is generally not recommended, but it can be helpful if you know what you're doing.

## Requirements

- Ruby 3.0 or higher
- No external dependencies

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gorodulin/alias_callable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
