# Pipeline rules

Shared by the stage skills: `ideate`, `shape`, `plan`, `build`.

## Artifacts

Each stage writes one markdown file to `~/code/plans/<worktree>/<project>/<feature>/`:

- `~/code/plans` is a bare repo with worktrees. `master` is the default worktree.
- When a new idea is begun, create a worktree and branch for it named after `<feature>`. The user merges it back and removes it.
- `<project>`: basename of the git root of the current directory
- `<feature>`: lower-case, dash-separated slug
- files: `ideate.md`, `shape.md`, `plan.md`

Create the folder if missing. Each stage reads only the artifact of the stage before it at the feature's rigor level.

## Commits

Artifacts in the plans repo and code in the project repo are committed the same way:

- The first write of an artifact or a piece of code is a normal commit.
- Every change the user points out after that is a fixup commit (`git commit --fixup=<sha>`) targeting the commit it belongs to.
- Never autosquash, amend, rebase or push unless explicitly told to. The user squashes, or drops a fixup they dislike.
- Never record a commit sha in an artifact. Squashing changes it.

## Rigor

`ideate.md` carries a line `rigor: hands-off | checkpoints | step-by-step`, chosen per feature. Default `checkpoints`. A project's CLAUDE.md may hint which level fits. Later stages read it from there. The user may edit it at any time.

It sets which stages run and how closely the user follows the code:

- `hands-off`: ideate → build. Only the end product matters. Build works out the approach itself, writes no shape or plan, and runs through without stops.
- `checkpoints`: ideate → shape → build. Build stops at the points that matter for the feature, and halts and asks when the code would need to depart from the shape's flow.
- `step-by-step`: ideate → shape → plan → build. Plan declares each function's test cases and the user checks them there. Build writes them as stated and halts and asks when the code would need a signature or a test case the plan does not have.

Each stage names the next stage of the feature's level when the user says it is done.

## Tests

How the code is tested is up to the project. Follow what its CLAUDE.md, readme or spec says about testing. Only when the project says nothing, fall back to the `acceptance-tests`, `unit-test-style` and `skill-test-sum-types` skills.

## Gates

- The user decides when a stage is done (see global CLAUDE.md).
- The stage's artifact is the running draft. Write it as soon as a first draft exists and
  keep it current; every later revision is a fixup commit. Never print a draft or any
  markdown in the terminal; the file is where it is discussed, the reply says in one line
  what changed.
- A stage is never done until the user says so. Name the next stage only then.
- If a later stage shows an earlier artifact is wrong, reopen that stage. Do not patch around it.

## Writing

Applies to every artifact and to the replies about it.

- Keep fact, proposal and decision apart. Never mix two of them in one section.
  - **Fact** is how the code behaves today. Present tense, under a heading that says so:
    `### Today`, `### Existing: id resolution`. Name the module it comes from.
  - **Proposal** is what the stage suggests. Its heading starts with `Proposed:` and its
    sentences say `would`: "The persist listener would read the matching documents before
    the write." Never "is added", "gets" or "has" for something that does not exist yet;
    read on its own, that sentence claims it is already there.
  - **Decision** is what the user has settled. A yes/no decision goes into the draft as a
    checklist item phrased as a statement, `- [ ] A deleted project deletes its view row.`
    A checked item is a yes. Anything else the user handles in the file or in the
    conversation. A proposal the user has accepted is written as a decision, not left as a
    proposal.
- Explain with examples. A mechanism is shown as a code example, a data shape as example
  data: a document, a payload, a table of rows. Show the same example before and after the
  change, so the reader sees what moves. Prose says what the example shows; it does not
  replace it. The stages' "no code" rule forbids implementation, not illustrative snippets.

## Focus

- Stay with what the idea touches. Do not bring in modules, consumers or earlier work the
  user has not connected to it, even when the codebase shows them nearby.
- Something the user decides to exclude goes under `## Out of scope` in the stage's draft,
  so later stages see it. It is not raised again.
