---
name: plan
description: 'Third pipeline stage. Turns the approach from /shape into code on a feature branch: typed stubs, failing tests and acceptance scenarios, plus an ordered task list. Invoke with /plan [feature].'
disable-model-invocation: true
---

# Plan

Turn the approach into a diff: typed stubs and failing tests that define the work, plus the order to build it in. No implementation.

Read `../pipeline/rules.md` first. Its artifact and gate rules apply.

## Input

Read `shape.md` of the feature, and the `rigor` line of its `ideate.md`.

- Feature given as an argument: use that folder.
- Nothing given: list the features of the current project and ask which.
- No `shape.md`: say so and stop.

Do not reopen what the shape decides. If the shape turns out to be wrong, say so and reopen `/shape`.

## Process

1. Read the codebase at file level: the files, functions and tests the shape touches. Find how the project tests (unit runner, Cucumber or both) and follow it.
2. Require a clean working tree. If it is dirty, say so and stop.
3. Create a branch named after the feature slug, or a worktree if the repo has a worktree layout.
4. Write the stubs:
   - typed inputs and outputs, bodies unimplemented
   - extend existing modules where the behavior belongs to them
5. Write the tests:
   - acceptance scenarios, where the project uses Cucumber: follow the `acceptance-tests` skill, step definitions included
   - unit tests named as behavior, "it returns x for y", following the `unit-test-style` and `skill-test-sum-types` skills
6. Run the project's type check and tests. Types must compile. Every new test must fail because the stub is unimplemented, and for no other reason. Fix anything that fails for another reason.
7. Split the work into ordered tasks, each making a named group of tests pass and leaving the code working.
8. Keep the running draft of the task list in `plan.md` from the first task on. Update it when a decision changes it and commit a fixup. Never print it in the terminal. Then keep going.
9. When the user says the stage is done, commit the stubs and tests and name the build step as the next stage.

## Rigor

- `hands-off`: the level is the user's go-ahead. Commit and write `plan.md` without a review round, and name the build step.
- `checkpoints`: the diff is the review step. Commit code only when the user says to.

## Output format

`plan.md` in the plans repo holds the order. The code holds the contract.

```markdown
# <title>

rigor: <level>
branch: <branch>

## Tasks

### 1. <task>
tests: <test names or scenario titles it turns green>

### 2. <task>
tests: ...
```
