# alias_callable Ruby gem

> **Keywords:** #alias #method #function #callable #ruby #gem #p20240728a #dependency #inclusion #service-objects #testing #mocking #stubbing #architecture #pattern #clean-code #refactoring #decoupling #injection #metaprogramming #delegation

**Transform your service objects and callable classes into clean, testable methods with the Dependency Inclusion Pattern.**

[![Gem Version](https://img.shields.io/gem/v/alias_callable.svg)](https://rubygems.org/gems/alias_callable)
[![Ruby](https://img.shields.io/badge/ruby-3.0%2B-red.svg)](https://www.ruby-lang.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Overview

The `alias_callable` gem introduces a powerful pattern for managing dependencies in Ruby applications. Instead of directly calling service objects throughout your code, you can alias them as methods, creating cleaner, more testable, and more maintainable code.

### Problems Solved

- **Tight Coupling**: Eliminates direct references to service classes throughout your code
- **Hidden Dependencies**: Makes all dependencies visible at the top of each class
- **Testing Complexity**: Simplifies mocking and stubbing in tests
- **Verbose Code**: Replaces long namespace paths with short, readable method names
- **Refactoring Friction**: Centralizes dependency definitions for easier updates
- **Context Management**: Automatically passes instance variables to service objects

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alias_callable'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install alias_callable
```

You can either enable `alias_callable` globally for all classes:

```ruby
# In your application initialization
AliasCallable.enable_globally

# Now you can use alias_callable in any class without including the module
class AnyClass
  alias_callable :my_service, ::MyService
end
```

or extend this feature on a per-class basis:

```ruby
class AnyClass
  extend ::AliasCallable::ClassMethods # <- this brings the alias_callable method explicitly

  alias_callable :my_service, ::MyService
  # ...
end
```

## Usage

### Basic Usage

```ruby
# Define your service objects
class FetchUserData
  def self.call(user_id)
    # ... fetch user data from database
    { id: user_id, name: "John Doe" }
  end
end

class SendNotification
  def self.call(message, recipient)
    # ... send notification logic
    puts "Sending '#{message}' to #{recipient}"
  end
end

# Use alias_callable to include them as methods:

class UserController
  # Dependencies are clearly visible at the top
  alias_callable :fetch_user, ::FetchUserData
  alias_callable :send_notification, ::SendNotification
  
  def show_user(id)
    user = fetch_user(id)  # Instead of FetchUserData.call(id)
    send_notification("User loaded", user[:name])
    user
  end
end
```

### Auto-Fill Instance Variables

You can automatically pass selected instance variables to your service objects. This is useful when you need to handle cross-cutting concerns like logging, database connections, or credentials.

```ruby
class CreateOrder
  def self.call(logger:, **attributes)
    logger.info("Creating order with #{attributes}")
    # Order creation logic
    { id: rand(1000), **attributes }
  end
end

class Orders::ProcessOrder
  alias_callable :create_order, ::CreateOrder, auto_fill: [:logger]
  
  def initialize(items:, customer_id:, logger:)
    @items = items
    @customer_id = customer_id
    @logger = logger
  end
  
  def call
    # The logger instance variable is automatically passed
    order = create_order(items: items, customer_id: customer_id)
    puts "Order #{order[:id]} created successfully"
  end
end

logger = Logger.new($stdout)
processor = Orders::ProcessOrder.new(items: ["Book", "Pen"], customer_id: 456, logger: logger)
processor.call
```

### Testing Made Easy

The pattern dramatically simplifies testing by providing clean mocking points:

```ruby
# In your test file
RSpec.describe UserController do
  let(:controller) { UserController.new }
  
  describe '#show_user' do
    it 'fetches and displays user data' do
      # Easy to mock the aliased callable
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

## Benefits

### Before alias_callable:

```ruby
class OrderController
  def create_order(params)
    # Dependencies scattered throughout the code
    user = ::DataLayers::FindUser.call(params[:user_id])
    order = ::Services::CreateOrder.call(user: user, items: params[:items])
    ::Services::SendEmail.call(order: order, template: :order_confirmation, logger: logger)
    ::Services::UpdateInventory.call(items: params[:items], action: :reserve)
    order
  end
end
```

### With alias_callable:

```ruby
class OrderController
  
  # All dependencies clearly visible at the top
  alias_callable :create_order, ::Services::CreateOrder
  alias_callable :find_user, ::DataLayers::FindUser
  alias_callable :send_email, ::Services::SendEmail, auto_fill: [:logger]
  alias_callable :update_inventory, ::Services::UpdateInventory
  
  def create_order(params)
    # Clean, readable method calls
    user = find_user(params[:user_id])
    order = create_order(user: user, items: params[:items])
    send_email(order: order, template: :order_confirmation)
    update_inventory(items: params[:items], action: :reserve)
    order
  end
end
```

## Best Practices

- Order alias methods alphabetically.
- Always use full class names prefixed with `::`. This will make it easier to find and replace dependencies when you rename classes and namespaces.

```ruby
class OrderController
  # Alphabetic order, full class names:
  alias_callable :create_order, ::Services::CreateOrder
  alias_callable :find_user, ::DataLayers::FindUser
  alias_callable :send_email, ::Services::SendEmail, auto_fill: [:logger]
  alias_callable :update_inventory, ::Services::UpdateInventory
end
```

- Prefer using `auto_fill` only for passing auxiliary context (loggers, trackers, credentials, connections).

## Advanced Features

### Backtrace Filtering

Clean up your backtraces by filtering out alias_callable internals:

```ruby
AliasCallable.enable_backtrace_filtering
```

Filtering backtraces is generally not recommended, but it can be helpful in some cases.

### Class and Instance Methods

`alias_callable` works with both instance and class methods, automatically detecting the appropriate context.

## Requirements

- Ruby 3.0 or higher
- No external dependencies

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gorodulin/alias_callable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
