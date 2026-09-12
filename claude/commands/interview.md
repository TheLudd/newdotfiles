---
name: interview
description: Conducts a deep implementation interview by first asking the user to state their request, then clarifying all ambiguities before building the implementation.
disable-model-invocation: true
tools:
  - AskUserQuestionTool
---
# Interview Skill

## Purpose

This skill captures the user's request — either inline as arguments to the skill, as a referenced document (file path or URL), or by prompting for it when no arguments are given.

Once the request is captured, the skill conducts a comprehensive, in-depth interview to clarify every ambiguity and hidden assumption before building the implementation.

The goal is to eliminate uncertainty across:

- Technical architecture
- System boundaries
- Edge cases
- UI and UX decisions
- Performance expectations
- Constraints
- Tradeoffs
- Security considerations
- Failure modes
- Data modeling
- Integrations
- Deployment environment
- Testing strategy
- Maintenance concerns

Questions must go beyond surface-level clarification and focus on uncovering implicit decisions, edge conditions, and architectural risks.

## Process

1. Determine the request source:
   - **No arguments** (just `/interview`): ask the user **"State your request."**
   - **Inline arguments** (e.g. `/interview do this and that`): treat the arguments as the stated request.
   - **Document reference** (e.g. `/interview ./spec.md`, `/interview path/to/doc.md`, or a URL): read the referenced document in full and treat its contents as the stated request.
2. If a document was referenced:
   - Use it as the source of truth for what is already decided — do not re-ask anything it already specifies.
   - Only interview around what the document leaves ambiguous, unstated, or implicitly assumed.
3. Once the request is captured, begin a structured and rigorous interview using `AskUserQuestionTool`.
4. Ask one focused, non-obvious question at a time.
5. Follow up on vague answers.
6. Probe architectural implications and tradeoffs.
7. Explore edge cases and failure scenarios.
8. Continue the interview until:
   - No ambiguity remains.
   - Technical direction is clear.
   - Tradeoffs are explicitly decided.
   - Edge cases are addressed.
   - Constraints are well defined.
9. Once the implementation is fully clarified, begin building immediately:
   - Use the original request (or referenced document) as the goal.
   - Use the interview answers as the decision record — do not re-decide anything the user already answered.
   - For any detail not covered in the request or interview, ask before assuming.

## Detecting a document reference

Treat the argument as a document reference when it looks like a path or URL rather than a sentence:
- Starts with `./`, `../`, `/`, `~/`, or a drive letter.
- Ends with a file extension like `.md`, `.txt`, `.pdf`, `.rst`, `.adoc`.
- Is a single token with no spaces that resolves to an existing file.
- Is an `http://` or `https://` URL.

When in doubt, prefer reading it as a document if the file exists; otherwise treat it as an inline request.

## Rules

- If invoked with no arguments, begin by asking the user to state the request.
- If invoked with a document reference, read the document before asking any questions and treat its contents as binding.
- Never re-ask anything the user already answered inline or in the referenced document.
- Use `AskUserQuestionTool` for all interview questions.
- Ask one question at a time.
- Avoid obvious or trivial questions.
- Surface hidden complexity.
- After the interview, build — do not write a spec.
- Treat interview answers as binding decisions. Do not override or reinterpret them.
- If a new ambiguity surfaces during building, stop and ask before proceeding.
