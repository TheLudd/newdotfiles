---
name: plan
description: 'Third pipeline stage, for step-by-step features only. Turns the shape from /shape into the functions to create, their signatures and the calls between them, as one nested call block per entry point. Invoke with /plan [feature].'
disable-model-invocation: true
---

# Plan

Turn the shape into the contract for the code: which functions exist, their signatures and how they call each other. The contract is a call block, not prose. No implementation, no branch.

Read `../pipeline/rules.md` first. Its artifact, gate, test, focus and writing rules apply.

## Input

Read `shape.md` of the feature, and the `rigor` line of its `ideate.md`.

- Feature given as an argument: use that folder.
- Nothing given: list the features of the current project across all plans worktrees and ask which.
- No `shape.md`: say so and stop.
- Rigor other than `step-by-step`: the feature skips this stage. Say so and ask before going on.

Do not reopen what the shape decides. If the shape turns out to be wrong, say so and reopen `/shape`.

## Conversation

- Read the codebase at file level: the files, functions, types and tests the shape touches.
- Write one call block per entry point of the shape's flow. Extend existing modules where the behavior belongs to them.
- Keep the running draft in `plan.md` from the first block on. Update it when a decision changes it and commit a fixup. The reply says in one line what changed.
- When the user says the stage is done, name `/build` as the next stage.

## Call blocks

A call block is a fenced code block in the project's language. Each function appears as its full signature. Under it, indented one level, the functions it calls, in call order, each with its own signature the first time it appears and as a bare call after that. Existing functions appear the same way, marked `// existing`. A branch is a comment line, `// fallback`, with the calls of that branch under it. A repeated call is a trailing comment, `// per view`.

Nothing else goes in a block: no bodies, no control flow, no variables. The block is the contract; `/build` writes what is inside.

Above each block, a heading names the entry point. Prose outside the blocks says only what a signature cannot: a type's meaning, a fact of the codebase a signature depends on.

Which file holds which function is a reference list at the end of the draft, one file per line, not part of the blocks.

```ts
applyChangeToView(view: MaterializedView, change: GenericChange): RTF<Error, void, CollectionDBEnv>
  classifyChange(view, change): Classification
    isRelevantChange(view, change): boolean
      collectOperatorPaths(change.data.operators): string[]
    classifyBaseChange(view, change): IdSource[] | 'fallback'
      findNamedValues(change.data.query, '_id'): Id[] | null
  // skip
  // fallback
  repopulateView(view): RTF<Error, void, CollectionDBEnv>
  // recompute
  resolveAffectedIds(view, sources): RTF<Error, Id[], CollectionDBEnv>
    resolveIdSource(view, source): RTF<Error, Id[], CollectionDBEnv>   // per source
      dbOperations.distinct(collection, field, query)                   // existing
      collectIds(result): Id[]
  recomputeRows(view, ids): RTF<Error, ViewRow[], CollectionDBEnv>
    dbOperations.aggregate(view.base, createRecomputePipeline(view, ids))   // existing
```

## Draft

```markdown
# <title>

## Types
<new and changed types, as code>

## <entry point>

```<lang>
<call block>
```

## <entry point>
...

## Tests
<test file per function, the cases in one line each>

## Files
- `<path>`: <functions>
```
