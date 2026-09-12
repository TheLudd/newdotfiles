---
name: unit-test-style
description: Use when writing unit tests where functions depend on a setup of state for different cases.
---

# Unit Test Style

Do state setup in `beforeAll`/`beforeEach`. Avoid duplicating setup code between tests.
The perfect `it` clause is just one line that does an assert but more lines are ok if it is needed for that single test.

Each `describe` block that needs different state should create its own isolated instances.

Name describe blocks to read as sentences: "useEntity when cached returns the entity as value"
