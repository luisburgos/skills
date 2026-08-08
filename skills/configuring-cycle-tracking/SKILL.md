---
name: configuring-cycle-tracking
description: >
  One-time setup for cycle tracking — writes the config and an empty history so
  the first cycle can begin.
disable-model-invocation: true
---

# Configuring cycle tracking

Sets up the artifact root, the repos to scan, the task source, and the timezone.
Writes two files and stops.

Consult the `engineering-cycle-model` skill for the layout and the loop this
config feeds.

This skill does **not** write goals. `setting-cycle-goals` owns the goals format
and handles the cold start, so the estimate fields live in one place.

## 1. Check whether config already exists

Look for `config.json` under the root the user names, and walk up from the
current directory for an existing one.

Found → this is a **re-run**. Show the current config and ask what to change.
Never overwrite a live config silently: the roots and timezone are what every
frozen figure in `history.jsonl` was computed under, and changing them
retroactively makes past cycles incomparable.

**Done when** you know this is a first setup or a re-run, and on a re-run the
user has said what changes.

## 2. Interview

Ask these together, with your best guess pre-filled, rather than one at a time:

- **Artifact root** — where cycle directories live. Default: a `cycles/`
  directory in the current repo.
- **Roots to scan for git repos** — directories to walk, not individual repos.
  Look at the user's filesystem for plausible candidates rather than guessing
  blind.
- **Excludes** — paths under those roots to skip. Archive and vendored-clone
  directories belong here; commits in an archive are not this cycle's work.
- **Author identity** — the git email whose commits count. Read
  `git config user.email` and offer it.
- **Timezone** — an IANA name (`America/Mexico_City`). Read the system zone and
  offer it. This decides which cycle a Sunday-night commit lands in.
- **Task source** — optional. Whether a hand-placed export enriches the git
  record.

**Done when** every field has a value the user has seen and accepted.

## 3. Write the config

```json
{
  "unit": "iso-week",
  "timezone": "America/Mexico_City",
  "artifact_root": "cycles",
  "scan_roots": ["~/Work/Projects"],
  "exclude": ["~/Work/Archive"],
  "author_email": "hola@luisburgos.xyz",
  "task_source": {
    "kind": "drop-folder",
    "path": "cycles/raw-data",
    "files": ["tasks.json", "projects.json"]
  }
}
```

`unit` is `iso-week` and nothing else — it is recorded so history rows stay
self-describing when a second unit becomes supportable, not because one exists.

Omit `task_source` entirely when the user declines it. Git alone is a complete
configuration.

**Done when** `config.json` exists at the root and every path in it resolves.

## 4. Create the directories and the empty history

- The artifact root.
- `raw-data/` under it, when a task source was configured. Tell the user this is
  where the export files go, by name.
- `history.jsonl`, **empty**.

History starts empty and accumulates honestly. Retroactive estimates are not
estimates, so there is nothing to backfill and no import path for one.

**Done when** both directories exist and `history.jsonl` is present and empty.

## 5. Point at the first cycle

Setup produces no goals. Tell the user what closes the gap:

> Config written. Run `setting-cycle-goals` to write the first cycle's goals —
> with no prior cycle on disk it drafts fresh rather than carrying anything over.

When a task source was configured, add that the export files must be in
`raw-data/` before the first `collecting-cycle-data` run.

**Done when** the user knows the next command and where exports go.
