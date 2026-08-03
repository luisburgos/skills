---
name: drafting-release-notes
description: >
  Draft curated GitHub Release notes for an existing tag — themed sections, PR
  and commit references, a collapsible full commit list, a compare link — as a
  draft the user approves before it goes public. Use when the user wants to cut
  a GitHub release, write notes for a tag or version, publish a release page, or
  has just bumped and tagged a version. Also use to rewrite an existing
  release's thin notes. This is the GitHub Releases page — not Play Store or
  TestFlight store copy, which is a separate concern with character limits and
  per-locale files.
---

# Drafting release notes

A release page is **public, outward-facing copy**, and the kind that gets edited
two or three times before it is right. So the release stays a **draft** until the
user says a publish word — that is where the editing happens, safely.

This skill releases *against* a tag. Version bumps, pushes, and the tag itself
belong to the repo's own release flow.

## 1. Confirm there is a tag to release against

Run `gh` commands directly and handle failure rather than pre-checking auth
(`gh <cmd> || echo "Run: gh auth login"`).

The tag must exist **on the remote** — `git tag -l <tag>` locally, and
`gh api repos/<owner>/<repo>/git/refs/tags/<tag>` 404s if it was never pushed.

- **Local-only** → `git push origin <tag>`.
- **No tag at all** → stop and confirm before creating one. Read the intended
  version from the repo's version source: `package.json` `"version"` for a
  web/TS repo, `pubspec.yaml` `version: X.Y.Z+build` for a Flutter app (use just
  the `X.Y.Z`). Match the repo's tag-prefix convention, create and push the tag
  against the release commit, then continue. Creating a *new* tag is fine with
  confirmation; **moving or re-pointing an existing tag is not.**

**Done when** the tag resolves on the remote, and any tag you created was
confirmed by the user first.

### When "release notes" is ambiguous

For a Flutter app, a bare "write the release notes" — especially alongside "RC",
"release candidate", or "cutting the build" — may mean the GitHub Release page or
the app-store copy. They are different documents, so producing the wrong one
wastes the user's time.

Ask **fast and light**: one line naming both options, your best guess, one
question. For a web repo there is no store side — proceed without asking.

> Quick check — for an RC, "release notes" could be the **GitHub Release page**
> or the **store notes**. For an RC I'd guess store notes — which do you want?

Anything that already pins it down (a compare link, a tag, "the github release")
→ skip the question. A character limit, a store locale, "What's New", or
"TestFlight" → this is the wrong skill; say so.

## 2. Determine the range

Notes cover everything since the **previous meaningful release** — usually the
previous tag. When intermediate patch tags shipped with no rich release of their
own, the user may want them folded in: ask when it is ambiguous ("just what this
tag added over the previous one, or everything since the last release with real
notes?").

```sh
git log --oneline <prev-tag>..<this-tag>
```

**Done when** both ends of the range are fixed and, where it was ambiguous, the
user chose.

## 3. Gather the material

Commit subjects alone produce a thin, inaccurate narrative. Pull the substance:

```sh
# Merged PRs in the range, with authors:
gh pr list --repo <owner>/<repo> --state merged --limit 40 \
  --json number,title,author,mergedAt,mergeCommit \
  -q '.[] | "\(.number)\t\(.mergeCommit.oid[0:7])\t@\(.author.login)\t\(.title)"'

# Does this commit have an associated PR? (empty = direct commit)
gh api repos/<owner>/<repo>/commits/<sha>/pulls -q '.[0].number'

# The marquee PR's body usually carries the real story:
gh pr view <NN> --repo <owner>/<repo> --json body -q .body

# Direct-commit bodies carry the "why":
git log -1 --format='%s%n%n%b' <sha>
```

Whether work landed via PR or direct commit is **per-era, not per-repo** — the
same repo often has PR-cited older changes and direct-commit newer ones. Resolve
it **per commit**, and cite `#NN` for PR-merged work, a short SHA for direct
commits.

A `CHANGELOG.md` entry for this version is a strong scaffold for the grouping,
though the release body is more narrative than the changelog, not a copy of it.

**Done when** every commit in the range is resolved to a `#PR` or a short SHA,
and the marquee changes have their PR or commit bodies read.

## 4. Learn the repo's two conventions, then draft

**Tag prefix** — bare (`0.16.0`) or `v`-prefixed (`v1.2.3`)?

```sh
gh api repos/<owner>/<repo>/tags --jq '.[].name' | head -8
```

Read the *version* tags and ignore housekeeping ones (`pre-v2-strip` and the
like). Prefix style is not guaranteed uniform across a repo's history — a project
can start `v`-prefixed and later switch to bare, so follow the **most recent**
version tags. The tag passed to `gh release` must match the actual tag; the title
is free text, so a repo can tag bare `0.16.0` while its release titles say
`v0.16.0 – Name`.

**Release-title style** — do prior releases carry a short name?

```sh
gh release list --repo <owner>/<repo> --limit 10
```

- Named (`v0.14.0 – New home`) → give this one a themed name too.
- Bare (`1.2.0`) → keep it bare.
- **No prior releases at all** — common in repos that keep a CHANGELOG but have
  never cut a release. There is no house style to match, so ask which the user
  wants, defaulting to what sibling repos do (the ecosystem leans toward
  `v{version} – {short name}`).

Then write the body to a **temp file** — never inline into the `gh` command,
since bodies are multi-line markdown.

**The body's structure and cadence are defined in
[notes-style.md](notes-style.md) — read it now and match it.** It carries the
section shape, the bold-lead-in + one-clipped-clause bullet form, the grouping
rules, the `<details>` commit list, and the compare link.

**Done when** the drafted body matches every section of `notes-style.md`, the
title matches the convention just read, and the tag string matches the real tag.

## 5. Create the draft and preview it

```sh
gh release create <tag> --draft \
  --title "<title matching repo convention>" \
  --notes-file <tmpfile> \
  --verify-tag
```

When the release **already exists** (rewriting or backfilling notes), edit it:

```sh
gh release edit <tag> --draft \
  --title "<title>" --notes-file <tmpfile>
```

Setting a published release back to `--draft` un-publishes it temporarily and
drops the Latest badge until it is re-published — tell the user before doing it.

Then **paste the drafted notes into chat** for review. Draft URLs read as
`untagged-…` until published; the tag is still attached.

**Done when** the draft exists on GitHub and its full body is in chat where the
user can read it.

## 6. Publish, once the user approves

Everything up to step 5 is read-only apart from creating the draft, which is why
the gate is cheap to honour. Apply whatever edits the user asks for
(`gh release edit --notes-file` again), re-preview, and publish only after they
approve in conversation — "publish", "looks good", "ship it".

```sh
# The newest release usually becomes Latest:
gh release edit <tag> --draft=false --latest

# An older version published alongside a newer one stays off Latest:
gh release edit <older-tag> --draft=false --latest=false
```

Publishing several at once: the older ones take `--latest=false` and the newest
takes `--latest`, so the badge lands on the right release.

**Done when** the user has approved in conversation and the final public URL is
confirmed back to them. Absent that approval, the release stays a draft — this is
the one step to never take on your own initiative.
