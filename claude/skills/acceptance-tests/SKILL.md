---
name: acceptance-tests
description: Use when writing acceptance (Cucumber/Gherkin) tests for a command, query or endpoint, and deciding what goes in a scenario versus a unit test. Acceptance tests assert the wiring, unit tests assert every variant.
---

# Acceptance tests

Acceptance tests assert the **wiring**. Unit tests assert **every variant** each wired part can take: validators, processors, observer handlers and handlers. The wiring code itself (command, query, observer and route definitions) is not unit tested.

If the project has its own testing skill or docs, follow them for file locations, naming and step layout. This skill decides what gets tested where.

## One scenario per wired part

For a command, query or endpoint, write exactly one scenario for each of:

- authorization (`Then I am denied`)
- the input schema (`Then I get a validation error`)
- each validator
- the processor
- success

Nothing more. A variant of a validator, the schema or the processor does not get its own scenario. It goes in a unit test. Several success scenarios are accepted when the wiring really differs, for example one per entity type stored in a different place. If the variation can be expressed in a unit test, that is better.

Order the feature file with all failing scenarios first and the succeeding ones last.

## The success scenario

One successful `When`, then a `Then` for the returned value and a separate `And` for each observer effect. Observers fire on the successful command, so their effects are asserted in the same scenario.

```gherkin
  Scenario: Success
    Given I am logged in as "Alice"
    And "OrgAlice" already has a campaign named "CampaignAlice"
    When I start a conversation for "OrgAlice" with subject "First" and the following participants:
      | Mike     |
      | Caroline |
    Then I receive the started conversation with subject "First" and the following participants:
      | Alice    |
      | Mike     |
      | Caroline |
    And the following users have been sent a "conversationMention" notification for "First"
      | name     | count |
      | Mike     | 1     |
      | Caroline | 1     |
```

If several steps are needed to reach the endpoint, chain them as `When`, `And`, `And`. Avoid a `Then` between `When`s.

## Extend before adding

Extend existing feature files and step definitions first. Add a new feature file or step file only when nothing fits. Put steps in the file of the entity they belong to.

## Step definitions

Write every step definition when writing the scenarios. A scenario with undefined steps fails for the wrong reason: it should fail because the code under test is unimplemented, not because a step is missing.
