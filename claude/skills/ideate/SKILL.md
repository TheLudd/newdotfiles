---
name: ideate
description: 'First pipeline stage. Turns a vague idea into a problem statement through a one-question-at-a-time conversation. No solutions, design or code. Invoke with /ideate [idea or path].'
disable-model-invocation: true
---

# Ideate

Turn an idea into a problem statement. Nothing else: no solutions, no design, no code.

Read `../pipeline/rules.md` first. Its artifact and gate rules apply.

The problem is rarely done. Do not hurry toward finishing. The user says when to move on.

## Input

- Inline text: that is the idea.
- A file path or URL: read it in full. Treat what it states as decided and ask only about what it leaves open.
- Nothing: ask "What's the idea?"

## Process

1. Restate the idea in one sentence and check it with the user.
2. Ask one question at a time. Follow up on every vague answer until it is concrete.
3. When the idea is a solution ("add a cache"), ask what hurts today until the problem underneath is visible.
4. Cover, in whatever order the conversation needs:
   - who has the problem
   - what hurts, and how it is handled today
   - what success looks like, stated so it could be proven false
   - what is out of scope
5. Keep the running draft in `ideate.md` from the restatement on. Update it when an answer changes it and commit a fixup. Never print it in the terminal. Then keep asking.
6. Never ask whether the problem is ready or nailed, and never propose moving on. If nothing is left to ask, say what is still weak in the draft.
7. When the user says the stage is done, ask for the `rigor` level if it was not given, set it in `ideate.md`, and name `/shape` as the next stage.

## Output format

```markdown
# <title>

rigor: checkpoints

## Problem
<2-3 sentences>

## Who
## Today
## Success
## Out of scope
```
