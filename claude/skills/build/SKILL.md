---
name: build
description: 'Last pipeline stage. Turns the last artifact of the feature into tested code on a feature branch, stopping for review as the rigor level says. Invoke with /build [feature].'
disable-model-invocation: true
---

# Build

Write the code the feature's artifacts describe, with its tests.

Read `../pipeline/rules.md` first. Its commit, rigor, test and focus rules apply.

## Input

- Feature given as an argument: use that folder.
- Nothing given: list the features of the current project across all plans worktrees and ask which.

Read the `rigor` line of the feature's `ideate.md`, then the artifact build starts from at that level. If it is missing, say so and stop.

- `hands-off`: `ideate.md`. Work out the approach yourself and do not write a `shape.md` or `plan.md`.
- `checkpoints`: `shape.md`.
- `step-by-step`: `plan.md`, and the scenarios in `shape.md`.

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

## Rigor

- `step-by-step`: before writing a function's tests, list its test cases in `plan.md` as checklist items under the function, `- [ ] it returns zero for a project without tasks`. Write the tests once the user has checked them. Halt and ask when a signature would differ from the plan.
- `checkpoints`: stop at the points that matter for this feature, such as a file format, a structure, or a chunk of working functionality. Halt and ask when the code would depart from the shape's flow.
- `hands-off`: no stops.
