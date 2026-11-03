---
name: plan
description: 'Third pipeline stage. Turns the shape from /shape into the ordered list of commits that build it, each with a short description of what it handles. Invoke with /plan [feature].'
disable-model-invocation: true
---

# Plan

Turn the shape into the commits that build it, in order. Each entry is a commit title and a short description of what that commit handles. No signatures, no test cases, no implementation.

Read `../pipeline/rules.md` first. Its artifact, gate, focus and writing rules apply.

## Input

Read `shape.md` of the feature.

- Feature given as an argument: use that folder.
- Nothing given: list the features of the current project across all plans worktrees and ask which.
- No `shape.md`: say so and stop.

Do not reopen what the shape decides. If the shape turns out to be wrong, say so and reopen `/shape`.

## Conversation

- Read the codebase at file level, enough to know where each part of the shape's flow lands.
- Cut the work into commits a reviewer can read on their own. Each commit leaves the type check and tests passing, carries the tests of what it adds, and handles one thing: a type, a module's part of the flow, a scenario wired end to end.
- Order them so each builds only on the ones before it.
- Keep the running draft in `plan.md` from the first list on. Update it when the user changes it and commit a fixup. The reply says in one line what changed.
- When the user says the stage is done, name `/build` as the next stage.

## Commits

Each commit is a numbered heading with its conventional commit title, followed by one to three sentences on what it handles and, when it matters, what it leaves for a later commit. The title is the message `/build` will commit with.

```markdown
### 1. feat(views): add MaterializedView and ViewRow types
The view definition and the row shape from the shape's model. No behavior yet.

### 2. feat(views): classify a change as skip, recompute or fallback
The classification step of the flow, with its unit tests. Nothing calls it yet.
```

## Draft

```markdown
# <title>

## Commits

### 1. <type>(<scope>): <subject>
<what it handles>

### 2. ...

<## Out of scope, when the user excludes something>
```
