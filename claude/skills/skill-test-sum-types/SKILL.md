---
name: skill-test-sum-types
description: Use when writing tests that assert on sum types or monads (Either, Maybe, Result, Resource). Compare against constructors directly instead of extracting values with helpers.
---

# Testing Sum Types and Monads

When testing sum types (Either, Maybe, Resource, Result, etc.), compare directly with constructors instead of using helper extraction functions.

## Anti-pattern

```typescript
const isRight = (either) => either.cata(() => false, () => true)
const getRight = (either) => either.cata(() => undefined, (r) => r)

expect(isRight(result)).toBe(true)
expect(getRight(result)).toEqual(expected)
```

## Correct pattern

```typescript
expect(result).toEqual(right(expected))
```

Single assertion verifies both the variant and the value. Better error messages, less code, more readable.
