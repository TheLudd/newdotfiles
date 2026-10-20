---
name: plan
description: 'Third pipeline stage, for step-by-step features only. Turns the shape from /shape into the functions to create, with their signatures and which calls which. No code. Invoke with /plan [feature].'
disable-model-invocation: true
---

# Plan

Turn the shape into the contract for the code: which functions exist, their signatures and how they call each other. Everything is markdown. No code, no branch.

Read `../pipeline/rules.md` first. Its artifact, gate, test and focus rules apply.

## Input

Read `shape.md` of the feature, and the `rigor` line of its `ideate.md`.

- Feature given as an argument: use that folder.
- Nothing given: list the features of the current project across all plans worktrees and ask which.
- No `shape.md`: say so and stop.
- Rigor other than `step-by-step`: the feature skips this stage. Say so and ask before going on.

Do not reopen what the shape decides. If the shape turns out to be wrong, say so and reopen `/shape`.

## Conversation

- Read the codebase at file level: the files, functions, types and tests the shape touches.
- List the functions to create or change, each with its signature and one line on what it does. Extend existing modules where the behavior belongs to them.
- Show the flow at function level: which function calls which, from the entry point down, following the shape's flow.
- Keep the running draft in `plan.md` from the first function on. Update it when a decision changes it and commit a fixup. The reply says in one line what changed.
- When the user says the stage is done, name `/build` as the next stage.

## Draft

```markdown
# <title>

## Functions
### `<module>/<file>`
<signature>
<one line on what it does>

## Flow
<who calls whom>
```
