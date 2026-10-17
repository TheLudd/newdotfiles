# Pipeline rules

Shared by the stage skills: `ideate`, `shape`, `plan`.

## Artifacts

Each stage writes one markdown file to `~/code/plans/master/<project>/<feature>/`:

- `~/code/plans` is a bare repo with worktrees. `master` is the default worktree. Use another worktree only when the user names it.
- `<project>`: basename of the git root of the current directory
- `<feature>`: lower-case, dash-separated slug
- files: `ideate.md`, `shape.md`, `plan.md`

Create the folder if missing. Each stage reads only the file of the stage before it.

## Commits

Artifacts in the plans repo and code in the project repo are committed the same way:

- The first write of an artifact or a piece of code is a normal commit.
- Every change the user points out after that is a fixup commit (`git commit --fixup=<sha>`) targeting the commit it belongs to.
- Never autosquash, amend, rebase or push. The user squashes, or drops a fixup they dislike.
- Never record a commit sha in an artifact. Squashing changes it.

## Rigor

`ideate.md` carries a line `rigor: hands-off | checkpoints`. Default `checkpoints`. Later stages read it from there. The user may edit it at any time.

- `hands-off`: after `/shape`, plan and build run through without review stops.
- `checkpoints`: the user reviews the plan diff, and build stops after each task.

Build halts and asks when the implementation would need a signature or test that differs from the plan, at either level.

## Gates

- The user decides when a stage is done (see global CLAUDE.md).
- Write the stage's artifact only when the user says to. Only then name the next stage.
- If a later stage shows an earlier artifact is wrong, reopen that stage. Do not patch around it.
