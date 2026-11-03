---
name: build
description: 'Last pipeline stage. Turns the last artifact of the feature into tested code on a feature branch, stopping for review as that artifact says. Invoke with /build [feature].'
disable-model-invocation: true
---

# Build

Write the code the feature's artifacts describe, with its tests.

Read `../pipeline/rules.md` first. Its commit, stage, test, focus and writing rules apply.

## Input

- Feature given as an argument: use that folder.
- Nothing given: list the features of the current project across all plans worktrees and ask which.

Start from the latest artifact the feature has. If it has none, say so and stop.

- `plan.md`: build commit by commit. Read `shape.md` too, for the approach, flow and scenarios.
- `shape.md`: build with checkpoints.
- `ideate.md` only: build hands-off. Work out the approach yourself and do not write a `shape.md` or `plan.md`.

Do not reopen what the artifacts decide. If one turns out to be wrong, say so and reopen its stage.

## Process

1. Require a clean working tree. If it is dirty, say so and stop.
2. If you are not already on a branch with a suitable name, create that branch named after the feature slug, or a worktree if the repo has a worktree layout.
3. When the feature has acceptance scenarios, write the feature files from them. Scaffold the step definitions and implement the steps that use existing code. A step that needs a new function is wired in once that function is done.
4. Build the functions, in any order. For each one:
   - its unit tests, named as behavior, "it returns x for y"
   - test doubles and fixtures as it calls for them; a function is tested against doubles of the functions it calls, never through them
   - its implementation, until its tests pass
5. Run the project's type check and tests before each commit.
6. Commit as you go, following the commit rules.

## Stops

- From `plan.md`: work through the commits of `plan.md` in order, one at a time. Find the next one by matching the branch's commit titles against the plan. Build only what that commit's description covers, commit it with the planned title, then stop and say in one line what it holds. Changes the user asks for are fixups of that commit. Go on to the next commit only when the user says so. Halt and ask when the work would not fit the planned commit, such as needing something a later commit holds or a commit the plan does not list.
- From `shape.md`: stop at the points that matter for this feature, such as a file format, a structure, or a chunk of working functionality. Halt and ask when the code would depart from the shape's flow.
- From `ideate.md`: no stops.
