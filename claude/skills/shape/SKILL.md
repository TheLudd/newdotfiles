---
name: shape
description: 'Second pipeline stage. Turns the idea from /ideate into an approach: decisions, flow between modules, scenarios, edge cases and test strategy. No code, no task list. Invoke with /shape [feature].'
disable-model-invocation: true
---

# Shape

Turn the idea into a technical approach the user can disagree with. Concrete enough to be wrong, not so concrete that it names files and functions. No code, no task order.

Read `../pipeline/rules.md` first. Its artifact, gate, test and focus rules apply.

## Input

Read `ideate.md` of the feature. It is the only input. Its opening section may be a problem, an idea, a feature or another framing; take it as written. Do not reopen what it decides.

- Feature given as an argument: use that folder.
- Nothing given: list the features of the current project across all plans worktrees and ask which.
- No `ideate.md`: say so and stop.
- Rigor `hands-off`: the feature skips this stage. Say so and ask before going on.

## Conversation

- Read just enough of the codebase to fit its patterns: the types in use and the module boundaries. File-level reading belongs to `/plan` and `/build`.
- When there is a real choice of approach, put the options next to each other with their trade-offs and recommend one. When one approach is clearly right, state it and why.
- Settle what the idea needs settled: often where state lives and the main types. Ask only what this approach needs.
- Write the flow: for each main action, the path it takes through the modules, in order, with what is passed along at each step. Modules only, no functions.
- When the feature needs acceptance tests, write the scenarios in Gherkin.
- Float edge cases the user may not have thought of. The user decides how each is handled, or rules it out.
- Decide the test strategy: what is unit-tested, what is acceptance-tested, where the seams are.
- Keep the running draft in `shape.md` from the first decision on. Update it when a decision changes it and commit a fixup. The reply says in one line what changed.
- If the idea turns out to be wrong, say so and reopen `/ideate`. Do not patch around it.
- When the user says the stage is done, name the next stage for the rigor level: `/build` for `checkpoints`, `/plan` for `step-by-step`.

## Draft

A title, `## Approach` with the chosen approach and why and any options rejected, and `## Flow`. Every other section comes from the approach, such as scenarios, types, edge cases, tests and out of scope.

```markdown
# <title>

## Approach
<chosen approach and why>

## Flow
<action>
  → <module>: <what it does, what it passes on>
  → <module>: ...

## Scenarios
<Gherkin, when the feature needs acceptance tests>

<sections the approach needs>
```
