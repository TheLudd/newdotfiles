---
name: shape
description: 'Second pipeline stage. Turns the problem statement from /ideate into an approach: decisions, types, boundaries, edge cases and test strategy. No code, no task list. Invoke with /shape [feature].'
disable-model-invocation: true
---

# Shape

Turn the problem statement into an approach the user can disagree with. Concrete enough to be wrong, not so concrete that it names files and functions. No code, no task order.

Read `../pipeline/rules.md` first. Its artifact and gate rules apply.

## Input

Read `ideate.md` of the feature. Its problem statement is the only input. Do not reopen what it decides.

- Feature given as an argument: use that folder.
- Nothing given: list the features of the current project and ask which.
- No `ideate.md`: say so and stop.

## Process

1. Read just enough of the codebase to fit its patterns: the types in use and the module boundaries. File-level reading belongs to `/plan`.
2. Put two or three approaches next to each other, with the trade-off of each. Recommend one and say why.
3. Settle the decisions where changing them later would redo several tasks:
   - where state lives and what owns what
   - what talks to what
   - the main types and their shapes, as concepts or a short type sketch
4. For each edge case and failure mode, decide how it is handled.
5. Decide the test strategy: what is unit-tested, what is integration-tested, where the seams are.
6. Keep a running draft. Show it when the user asks, or when a decision changes it materially. Then keep going.
7. If the problem statement turns out to be wrong, say so and reopen `/ideate`. Do not patch around it.
8. When the user says to save it, write `shape.md` and name `/plan` as the next stage.

## Output format

```markdown
# <title>

## Approach
<chosen approach and why, with the options rejected>

## Decisions
## Types and boundaries
## Edge cases
## Tests
## Out of scope
```
