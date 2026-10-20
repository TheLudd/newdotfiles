---
name: ideate
description: 'First pipeline stage. Turns an idea into a written understanding of it through conversation. No design or code. Invoke with /ideate [idea or path].'
disable-model-invocation: true
---

# Ideate

Understand the idea well enough that `/shape` can design it. Nothing else: no design, no code.

Read `../pipeline/rules.md` first. Its artifact, gate and writing rules apply.

An idea can be a problem to solve, a feature to add or a capability for a framework or an app. A feature does not need a problem behind it to be worth exploring.

Push back. Say so when the idea seems unclear, inconsistent with itself or with the codebase, or weaker than a nearby alternative, and ask why when the reason would change the idea. The user decides; the pushback is there so the idea is tested before it is designed.

## Input

- Inline text: that is the idea.
- A file path or URL: read it in full. Treat what it states as decided and ask only about what it leaves open.
- Nothing: ask "What's the idea?"

## Conversation

We are talking ideas together, the way two engineers would before anyone designs anything.

- Restate the idea and check it with the user. Start the draft in `ideate.md`.
- Ask only what this idea needs to be understood. There is no specific checklist of topics. A technical idea and an app idea raise different questions.
- When the conversation drifts into how to build it, notice it, and refocus on the idea unless the answer changes what the idea is.
- Update the draft when an answer changes it and commit a fixup. The reply says in one line what changed.
- Never ask whether the idea is ready and never propose moving on.
- When the user says the stage is done, ask for the `rigor` level if it was not given, set it in `ideate.md`, and name the next stage for that level: `/build` for `hands-off`, `/shape` otherwise.

## Draft

A title, the `rigor` line, and an opening section under the heading that fits the idea, such as `## Problem`, `## Idea` or `## Feature`. Every other section comes from the idea: background, flows, decisions, out of scope, whatever it needs.

```markdown
# <title>

rigor: checkpoints

## <Problem | Idea | Feature>
<2-3 sentences>

<sections the idea needs>
```
