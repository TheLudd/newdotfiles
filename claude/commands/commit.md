---
description: Create a commit with conventional commit format
---

Create a commit for the current changes.

## Commit Format

Use conventional commits: `type(scope): description`

- Header: max 72 characters
- Body: wrap at 80 characters, write in prose (no bullet lists)
- Focus on **why** the change was made, not what was changed.
  Answer: Why was this needed? What problem does it solve?
- Do not simply list the individual files or functions that were modified.
- If it is a simple change, keep it short. No need to over-explain.
- Do not include "Co-authored-by" trailers.
- If the branch name includes a tag matching DEV-XXXX, add a "Closes: DEV-XXXX" tag to the footer.

## Types

- `feat`: new additions to the exported API (new functions, new args)
- `fix`: changes that don't affect the API
- `chore`: no publish needed (pure refactorings)

## Scope Rules

Scope is the package name without the organization prefix: `@acme/users` → `users`

Multiple packages: `type(users,auth): description`

More than two packages: omit the scope entirely.

## Breaking Changes

Add an exclamaiton point before the colon: `feat(users)!: remove legacy auth`

Include a footer:
```
BREAKING CHANGE: explanation of what changed and how to migrate
```

Use for removed/renamed functions, changed arguments, or changed return values.
