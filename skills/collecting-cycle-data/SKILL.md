---
name: collecting-cycle-data
description: >
  Collect what actually happened in a cycle — git across the configured repos,
  plus an optional task export — into the cycle's primary record.
---

# Collecting cycle data

Mechanical. Produces `data.json`, the **primary record** every downstream figure
traces back to.

Consult the `weekly-cycle-model` skill for the layout, the time rules, and
the trust seam this skill anchors.

**This skill never reads `goals.md`.** The facts are gathered blind to the plan,
so they cannot be bent toward it.

## 1. Resolve the cycle and its window

Read `config.json` for the timezone, roots, excludes, and author emails.

**A config with no `scan_roots` has no git by design.** Skip this check, record
the git figures as absent rather than zero, and collect from the task source
alone. Git is recommended, not required, so its deliberate absence is a
configuration rather than a fault.

Where `scan_roots` is present, **stop before anything else when `author_emails`
is missing, empty, or not a list.** Do not fall back to `git config user.email`,
and do not run with no author filter.

Both failure modes are silent in the same direction: an empty filter tallies
zero commits, and a missing filter tallies *everyone's*. Neither raises an
error, and a frozen cycle of `0` is indistinguishable from a quiet week.

The old key was `author_email`, a single string. Name it in the message when you
find it, since that is the likely cause and the fix is mechanical:

> `config.json` has `author_email` (a string), which this skill no longer reads.
> Rename it to `author_emails` and make it a list — keep the address already
> there as the first entry. Add any other addresses whose commits should count:
> a work address, or the GitHub `noreply` address that web-UI merges are
> attributed to. Then re-run.

**Done when** `author_emails` is present and holds at least one address, or the
run has stopped with the rename spelled out.

The cycle id is an ISO week (`2026-W32`), defaulting to the week just ended.
Compute the window in the **configured timezone** — Monday 00:00:00 to Sunday
23:59:59 local, never UTC.

Getting this wrong is silent: UTC runs ahead of the Americas and rolls the week
early on Sunday evening, so Sunday-night commits land in the wrong cycle and
nothing complains.

**Done when** the cycle id and both window ends are fixed, stated in local time,
and the user has confirmed the cycle if it was not the one just ended.

## 2. Find the repos

**When the config has no `scan_roots`, skip to the task source.** Git is
recommended but not required, and a configuration without it is deliberate rather
than broken. Record the git figures as absent, not as zero: nothing was measured,
which is different from nothing having happened.

Otherwise walk each `scan_roots` entry for directories containing `.git`. Drop
anything under `exclude`.

Scanning roots rather than listing repos is what keeps a new project from going
uncounted. Report the repo list — a root that resolves to nothing is a config
error worth surfacing now, not after the figures are frozen.

**Done when** every scanned root has produced its repo list, exclusions are
applied, and the count is reported; or the config declares no git and that is
recorded.

## 3. Tally git

Per repo, over the window:

```sh
git -C <repo> log \
  --fixed-strings \
  --author="<author_emails[0]>" --author="<author_emails[1]>" \
  --first-parent \
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

- **`--fixed-strings` — always, not conditionally.** Without it `--author` is a
  regex, and every `.` in an address matches any character. A pattern ending
  `…github.co.` matches every commit from `…github.com`, its trailing `.`
  standing in for the `m`; with the flag it matches none. A configured address
  can therefore count commits that are not that author's. This flag makes
  matching a plain substring comparison, which is what the config means.

  Matching stays a **substring** test even with `--fixed-strings` — it is not
  anchored. A configured `dev@example.com` also matches a commit authored by
  `other-dev@example.com.mx`. Harmless for distinct addresses, worth knowing
  before adding a short one.

  De-duplicate by SHA across the identities anyway: git already collapses the OR
  to one row per commit, but a repo with mailmap rewriting or a re-run over
  overlapping config can double-count, and the tally is about to freeze.
- **`--first-parent`** — walk only the default branch's mainline. A merged
  branch counts as the single commit that landed it, not every commit it carried.
  Without it, a cycle that merges a long-lived branch shows a spike that measures
  branch age, not the cycle's work.
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

Skip entirely when `task_source` is absent. Git alone is a complete run, just as
a task source alone is a complete run when there is no git.

`config.json`'s `task_source` names how records reach the drop folder. This step
reads **task and project records** from that folder and does not know or name the
source that produced them. How a source is obtained and shaped — file locations,
APIs, export quirks, fields dropped in normalization — lives with the adapter,
not here. Read the configured files; missing files are not an error — say so and
continue with git.

### What a record must supply

The step needs a small set of **roles** filled. **Match each role by its
canonical key first; fall back to meaning if the key is absent.** A source that
uses the canonical names is read deterministically; one that names things
differently is still read, by description. Extra fields are ignored, never an
error. Input is tolerant; the `data.json` this step writes is canonical.

**Task identity** — the tally counts *distinct* tasks, so every task must be
tellable from every other. One requirement, in order of preference:

1. **Prefer a stable identifier** (`id`) — unique within the export, surviving
   re-export; a renamed task keeps its id.
2. **Fall back to the title** (the text role below) when no id exists. The title
   then *is* the identity, at the cost that **two tasks sharing a title count as
   one**. When you fall back this way, **say so** — "no stable ids; identical
   titles counted once" — so the duplicate under-count is never silent.
3. **Neither → the task cannot be counted.**

Other task roles:

| Role | Canonical key | Recognize by | Absent |
|---|---|---|---|
| completion time | `completed_at` | a date/datetime marking when the task was finished, ISO-8601 preferred | the task is **backlog** — out of every cycle |
| done signal | `done` | a boolean-ish "finished" flag | treat as not done |
| project reference | `project_id` | points the task at its project's identifier | **untagged** |
| text | `title` | the human-readable title; doubles as identity fallback when no `id` | with no id either, cannot be counted |

**Project identity** — everything downstream keys projects by **name**
(`by_project`, the color block, every chart), so a project must resolve to a name:

1. **Prefer a stable identifier** (`id`) — the value a task's project reference
   points at.
2. **Fall back to the name** (the name role below) when no id exists.
3. **Neither → skip the project**, and untag any task that pointed at it.

One difference from tasks, because the name is itself the key: a project with an
id but no name uses the **id as its name** — the join still works, the record
just reads by an opaque key.

Other project roles:

| Role | Canonical key | Recognize by | Absent |
|---|---|---|---|
| name | `name` | the display name, and the downstream join key; doubles as identity fallback when no `id` | with no id either, cannot be named — skip it |
| color | `color` | a display color for the project | omitted; the renderer owns the fallback |

### How a task maps to a cycle

A task's cycle is the ISO week — in the configured timezone — that contains its
**completion time**. A task with no completion time belongs to no cycle; it is
backlog. Its day within the cycle is the weekday of that same completion time,
clamped to the window. Week, day, and backlog are all read off the one timestamp;
there is no separate stored week to trust. A source may carry its own week field —
it is ignored, because deriving from the completion time is what keeps a task from
drifting between when it was filed and when it was finished.

### Staleness

The files are hand-placed, so they can be a previous cycle's export. Find the
newest completion time present:

- Inside the window → proceed.
- **Before the window** → warn loudly and stop for confirmation. A stale export
  freezes wrong figures permanently once the cycle is assessed.

> The newest completion time in the export is 2026-07-28, before this cycle's
> window (2026-08-03 to 2026-08-09). This export looks like a previous cycle's.
> Re-export and replace the files, or confirm to proceed with git only.

Count tasks completed inside the window, grouped by project.

### Carry the project colors

Each task's project reference resolves to a name through the project records,
which also carry a **color** role. Carry that color into `data.json` alongside the
tally, in a top-level `projects` block keyed by name.

Record a project the cycle actually touched — one appearing in `tasks.by_project`
or `commits.by_project`. A color for a project with no activity this cycle is
noise in a frozen record.

Colors are **collected, not invented**. A project the source has no color for is
omitted from the block rather than assigned one here; the renderer owns the
fallback. Do not de-duplicate colors that collide, and do not adjust them for
contrast — the record reports what the source said, and a color edited at
collection time would not match the tool the reader recognizes it from.

This is why the color is frozen into the cycle rather than looked up when the
review renders: re-rendering an old cycle must not repaint it in today's
palette. Same rule as every other figure here.

**Done when** the export is tallied, or its absence or staleness is stated
explicitly, and any colors the source carried are recorded.

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
  },
  "projects": {
    "netto": { "color": "#00d18b" }
  }
}
```

Omit `tasks` when no source was configured. Record `repos_scanned` alongside
`repos_touched` — a quiet cycle and a broken config produce the same commit
count, and only these two numbers together tell them apart.

`projects` is a **sibling** of the tallies, not a change to them. `by_project`
stays a flat `{name: count}` dict, because several consumers read it that shape
and none of them need the color. A reader wanting one project's color looks it
up by the same name it already has.

Omit the whole block when no source carried colors — git-only cycles have no
project list to read them from. An absent block is normal, not a fault: every
cycle frozen before this field existed lacks it, and they still render.

Keying it by name rather than by the source's own id keeps `data.json` readable
on its own and free of a foreign key pointing at a file it does not contain.
The name is already the join key everywhere else in this record.

**Done when** `data.json` exists in the cycle directory and its totals
reconcile. Re-add the breakdowns and check rather than assuming the tally was
right: per-repo and per-day sums against `commits.total`, per-project against
`tasks.total`.

Expect **one** legitimate inequality. Because `by_day` is window-clamped (§4), a
task completed inside the cycle but stamped outside the day-window counts in
`tasks.total` and in `by_project`, yet not in `by_day`. So `sum(by_day)` is `≤
tasks.total` by design — never force the sums to agree. Any *other* divergence is
a collection bug: stop and surface it, because these numbers freeze at assessment.

This reconciliation is the record's own guarantee. Downstream skills read
`data.json` trusting it already reconciles; they do not re-tally it.

## 6. Report and point onward

State the cycle, the window in local time, repos touched of repos scanned,
commit total, and task total or its absence.

> `2026-W32` collected — 34 commits across 2 of 7 repos, 12 tasks.
> Run `writing-cycle-review` for the narrative, or go straight to
> `assessing-cycle-goals`.

The review is optional and nothing machine-readable consumes it; assessment reads
`data.json`, not the narrative.

**Done when** the figures are in chat and the next command is named.
