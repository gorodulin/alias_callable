# Testing forwarding of Ruby method arguments across versions (including `ruby2_keywords`)

Why? Because the `.parameters` method returns different results depending on the Ruby version.

## Testing Ruby 2.5 (2.5.9)

- Running standard code (`ruby2_keywords` not available)
  - Standard method `(*args, **kwargs, &block)`: `[[:rest, :args], [:keyrest, :kwargs], [:block, :block]]`

## Testing Ruby 2.6 (2.6.10)

- Running standard code (`ruby2_keywords` not available)
  - Standard method `(*args, **kwargs, &block)`: `[[:rest, :args], [:keyrest, :kwargs], [:block, :block]]`

## Testing Ruby 2.7 (2.7.8)

- Standard method `(*args, **kwargs, &block)`: `[[:rest, :args], [:keyrest, :kwargs], [:block, :block]]`
- Without keywords `(*args, &block)`: `[[:rest, :args], [:block, :block]]`
- With `ruby2_keywords` applied: `[[:rest, :args], [:block, :block]]`

## Testing Ruby 3.0 (3.0.7)

- Standard method `(*args, **kwargs, &block)`: `[[:rest, :args], [:keyrest, :kwargs], [:block, :block]]`
- Without keywords `(*args, &block)`: `[[:rest, :args], [:block, :block]]`
- With `ruby2_keywords` applied: `[[:rest, :args], [:block, :block]]`

- Comparing with ... syntax (Ruby 3.0+)
  - Forward all arguments `(...)`: `[[:rest, :*], [:block, :&]]`

## Testing Ruby 3.1 (3.1.7)

- Standard method `(*args, **kwargs, &block)`: `[[:rest, :args], [:keyrest, :kwargs], [:block, :block]]`
- Without keywords `(*args, &block)`: `[[:rest, :args], [:block, :block]]`
- With `ruby2_keywords` applied: `[[:rest, :args], [:keyrest, :**], [:block, :block]]`
- Comparing with ... syntax (Ruby 3.0+)
  - Forward all arguments `(...)`: `[[:rest, :*], [:keyrest, :**], [:block, :&]]`

## Testing Ruby 3.2 (3.2.8)

- Standard method `(*args, **kwargs, &block)`: `[[:rest, :args], [:keyrest, :kwargs], [:block, :block]]`
- Without keywords `(*args, &block)`: `[[:rest, :args], [:block, :block]]`
- With `ruby2_keywords` applied: `[[:rest, :args], [:keyrest, :**], [:block, :block]]`

- Comparing with ... syntax (Ruby 3.0+)
  - Forward all arguments `(...)`: `[[:rest, :*], [:keyrest, :**], [:block, :&]]`

## Testing Ruby 3.3 (3.3.7)

- Standard method `(*args, **kwargs, &block)`: `[[:rest, :args], [:keyrest, :kwargs], [:block, :block]]`
- Without keywords `(*args, &block)`: `[[:rest, :args], [:block, :block]]`
- With `ruby2_keywords` applied: `[[:rest, :args], [:keyrest, :**], [:block, :block]]`

- Comparing with ... syntax (Ruby 3.0+)
  - Forward all arguments `(...)`: `[[:rest, :*], [:keyrest, :**], [:block, :&]]`

## Testing Ruby 3.4 (3.4.2)

- Standard method `(*args, **kwargs, &block)`: `[[:rest, :args], [:keyrest, :kwargs], [:block, :block]]`
- Without keywords `(*args, &block)`: `[[:rest, :args], [:block, :block]]`
- With `ruby2_keywords` applied: `[[:rest, :args], [:keyrest, :**], [:block, :block]]`

- Comparing with ... syntax (Ruby 3.0+)
  - Forward all arguments `(...)`: `[[:rest, :*], [:keyrest, :**], [:block, :&]]`


# Ruby Arguments Forwarding: Key Findings

Based on the test results, here are the main findings about Ruby's argument handling evolution:

## Key Observations

1. **Ruby 2.7 Introduction of `ruby2_keywords`**:
   - In Ruby 2.7, `ruby2_keywords` appears but doesn't change the parameter representation - still shows `[[:rest, :args], [:block, :block]]` without the explicit `keyrest` parameter

2. **Ruby 3.0+ Behavior Change with `ruby2_keywords`**:
   - Starting in Ruby 3.1, `ruby2_keywords` actually modifies the parameter representation to include `[:keyrest, :**]`, showing it's properly capturing keyword arguments

3. **Evolution of `...` Syntax**:
   - In Ruby 3.0, the `...` syntax shows `[[:rest, :*], [:block, :&]]` - missing the `keyrest` parameter
   - In Ruby 3.1+, the `...` syntax shows `[[:rest, :*], [:keyrest, :**], [:block, :&]]` - fully capturing all argument types

4. **Anonymous Parameters**:
   - The `...` syntax uses anonymous parameter names (`*`, `**`, `&`) instead of named parameters (`args`, `kwargs`, `block`)

## Practical Implications

- **Version-Specific Handling**: For cross-version compatibility, different approaches are needed:
  - Ruby 2.5-2.6: Must use explicit `*args, **kwargs, &block`
  - Ruby 2.7-3.0: Can use `ruby2_keywords` for transitional support
  - Ruby 3.1+: Can fully rely on `...` syntax or explicit parameters

- **Complete Support in Ruby 3.1+**: Only in Ruby 3.1 and above does the `...` syntax fully support all three parameter types (positional, keyword, and block)

