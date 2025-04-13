

- When alias method is private or protected.
  - It should be still possible to call it and stub it.
- When alias methods are defined in a module (as class methods).
  - It should be possible to list them and stub them without including the module.
- When alias methods are defined in a module (as instance methods)
  - 1) It should be possible to list them and stub them after including the module.
  - 2) when included in two different classes.
    - It should be possible to stub them in both classes separately (without affecting each other).
- When different callables are included under the same name from different modules.
  - The latter one should be used.
- When class.call passes args using old Ruby notation
  - We should collect the args from the target method and be able to autofill them
- When class.call passes args using new Ruby notation
- When class with aliased methods has subclasses
  - It should be possible to stub the aliased methods in the subclasses separately.
