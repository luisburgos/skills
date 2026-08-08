---
name: collecting-cycle-data
description: >
  Collect what actually happened in a cycle — git across the configured repos,
  plus an optional task export — into the cycle's primary record.
disable-model-invocation: true
---

# Collecting cycle data

Mechanical. Produces `data.json`, the **primary record** every downstream figure
traces back to.

Consult the `engineering-cycle-model` skill for the layout, the time rules, and
the trust seam this skill anchors.

**This skill never reads `goals.md`.** The facts are gathered blind to the plan,
so they cannot be bent toward it.

## 1. Resolve the cycle and its window

Read `config.json` for the timezone, roots, excludes, and author emails.

The cycle id is an ISO week (`2026-W32`), defaulting to the week just ended.
Compute the window in the **configured timezone** — Monday 00:00:00 to Sunday
23:59:59 local, never UTC.

Getting this wrong is silent: UTC runs ahead of the Americas and rolls the week
early on Sunday evening, so Sunday-night commits land in the wrong cycle and
nothing complains.

**Done when** the cycle id and both window ends are fixed, stated in local time,
and the user has confirmed the cycle if it was not the one just ended.

## 2. Find the repos

Walk each `scan_roots` entry for directories containing `.git`. Drop anything
under `exclude`.

Scanning roots rather than listing repos is what keeps a new project from going
uncounted. Report the repo list — a root that resolves to nothing is a config
error worth surfacing now, not after the figures are frozen.

**Done when** every scanned root has produced its repo list, exclusions are
applied, and the count is reported.

## 3. Tally git

Per repo, over the window:

```sh
git -C <repo> log \
  --author="<author_emails[0]>" --author="<author_emails[1]>" \
  --no-merges \
  --since="<window start>" --until="<window end>" \
  --date=iso-strict \
  --pretty=format:'%H%x09%ad%x09%s'
```

Three flags carry the decisions:

- `--author` — only the configured identities. **One flag per entry in
  `author_emails`**; repeated `--author` flags OR together, so a commit matching
  any configured address counts once. A shared repo otherwise inflates figures
  that are about to freeze.

  The value is a regex, not a literal — `.` matches any character, so two
  addresses differing only by a dot cross-match. Escape the dots (or pair the
  flags with `--fixed-strings`) when the configured addresses are close enough
  for that to matter.

  De-duplicate by SHA across the identities anyway: git already collapses the OR
  to one row per commit, but a repo with mailmap rewriting or a re-run over
  overlapping config can double-count, and the tally is about to freeze.
- `--no-merges` — a merge commit is not a unit of work.
- **`%ad` is the author date**, and `--since`/`--until` filter on it. Author date
  survives rebase; committer date does not, so a rebase in a later cycle would
  drag this cycle's work forward and change a number that is meant to be frozen.

Convert each author date into the configured timezone before deciding the day it
belongs to.

Collect subjects too, not just counts — `writing-cycle-review` needs the texture,
and re-deriving them later is exactly what the freeze forbids.

**Done when** every repo in the list has been queried, and each commit is
attributed to a local day inside the window.

## 4. Read the task export, if configured

Skip entirely when `task_source` is absent. Git alone is a complete run.

Read the configured files from the drop folder. Missing files are not an error —
say so and continue with git.

**Check the export for staleness.** The files are hand-placed, so they can be a
previous cycle's export. Find the newest completion timestamp in the export:

- Inside the window → proceed.
- **Before the window** → warn loudly and stop for confirmation. A stale export
  freezes wrong figures permanently once the cycle is assessed.

> The newest completed task in `tasks.json` is 2026-07-28, before this cycle's
> window (2026-08-03 to 2026-08-09). This export looks like a previous cycle's.
> Re-export from Birdseye and replace the files, or confirm to proceed with git
> only.

Count tasks completed inside the window, grouped by project.

**Done when** the export is tallied, or its absence or staleness is stated
explicitly.

## 5. Write `data.json`

```json
{
  "cycle": "2026-W32",
  "unit": "iso-week",
  "timezone": "America/Mexico_City",
  "window": { "start": "2026-08-03T00:00:00-06:00", "end": "2026-08-09T23:59:59-06:00" },
  "commits": {
    "total": 34,
    "by_repo": { "skills": 12, "netto": 22 },
    "by_day": { "2026-08-03": 5 },
    "subjects": [
      { "repo": "skills", "sha": "a3d78b6", "date": "2026-08-03T14:02:11-06:00", "subject": "…" }
    ]
  },
  "repos_touched": 2,
  "repos_scanned": 7,
  "tasks": {
    "source": "drop-folder",
    "export_newest": "2026-08-09",
    "total": 12,
    "by_project": { "netto": 8 }
  }
}
```

Omit `tasks` when no source was configured. Record `repos_scanned` alongside
`repos_touched` — a quiet cycle and a broken config produce the same commit
count, and only these two numbers together tell them apart.

**Done when** `data.json` exists in the cycle directory and its totals match the
per-repo and per-day breakdowns. Re-add them and check rather than assuming the
tally was right.

## 6. Report and point onward

State the cycle, the window in local time, repos touched of repos scanned,
commit total, and task total or its absence.

> `2026-W32` collected — 34 commits across 2 of 7 repos, 12 tasks.
> Run `writing-cycle-review` for the narrative, or go straight to
> `assessing-cycle-goals`.

The review is optional and nothing machine-readable consumes it; assessment reads
`data.json`, not the narrative.

**Done when** the figures are in chat and the next command is named.
