# The release body — format

The reference implementation for what "good" looks like. When drafting a release
body, match this structure and cadence.

## The shape of a release body

```
<one- or two-sentence intro — the theme of the release, in plain language>

## <emoji> <Theme section>

- **<bold lead-in phrase>.** <one clipped clause saying what changed>. (#PR or `sha`)
- **<bold lead-in phrase>.** <one clipped clause>. (#PR or `sha`)

## <emoji> <Another theme section>

- ...

## 👋 New contributors   ← only if someone made their first contribution

- @handle made their first contribution in #NN — thanks!

---

<details>
<summary>Full commit list (since <prev-version>)</summary>

* <commit subject> by @author in <PR url>            ← for PR-merged work
* <commit subject> ([<short-sha>](<commit url>))     ← for direct commits
...

</details>

**Full Changelog**: https://github.com/<owner>/<repo>/compare/<prev-tag>...<this-tag>
```

## The cadence that matters most

Each bullet is a **bold lead-in phrase + one clipped clause**, then the
reference. Not two or three sentences. This is the single thing most worth
getting right — early drafts tend to run long, and the fix is always to cut,
not to add. Compare:

- ❌ Too long: "**Draggable sidebar.** The sidebar now renders the same full
  card as everywhere else, and it's fully draggable — drag cards out to a day or
  the unscheduled tray, drag them in, or reorder within the tray by its grip.
  Dropping onto an occupied slot does a true slot swap."
- ✅ Right: "**Draggable sidebar.** Slots now render full cards — drag out, drag
  in, reorder, or drop onto an occupied slot to **swap**. (`6280f36`)"

Describe **what changed for the user**, not the internal mechanism. The reader
is someone deciding whether to update, or a curious user — not a code reviewer.

## Grouping

- Group changes into 2–4 **themed sections** with an emoji + short title
  (`## 🏠 Home`, `## ⚡ Capture & focus`, `## 📊 Metrics fixes`,
  `## 🧹 Polish & fixes`, `## 🧭 Navigation & layout`, `## 🧹 Under the hood`).
  Themes come from *what the work was about*, not from commit `type:` prefixes —
  a `feat` and a `fix` on the same feature belong in the same section.
- Order sections by user impact: the headline feature first, polish/under-the-hood
  last.
- Omit a section if it has nothing real in it. Don't pad.

## References: PR number vs commit SHA

Cite whatever actually carried the change:

- Work that landed via a **merged PR** → `(#68)` in the bullet, and
  `* <subject> by @author in <PR url>` in the full commit list.
- Work committed **directly** (no PR) → `` (`6280f36`) `` in the bullet (a short
  SHA in backticks), and `* <subject> ([<short-sha>](<commit-url>))` in the
  list — short SHA as the link text, the full SHA in the URL.

A single release usually mixes both. Check per commit — don't assume.
(`gh api repos/<owner>/<repo>/commits/<sha>/pulls` tells you if a commit had a PR.)

## The intro line

One or two sentences naming the theme. It should read like a person describing
the release, not a changelog header. Examples:

- "Two separate views merged into a single **Home** week view, the **Calendar**
  returned as a real projection, and capture and filtering got sharper."
- "Capture and completion get more tactile — a unified quick-add, a draggable
  sidebar, and press-and-hold Done — plus a batch of chart fixes."

## The `<details>` full commit list

A collapsible `<details>` block holding every commit/PR in the range, so the
curated sections stay skimmable while the complete list is one click away. Label
its summary with the span, e.g. `Full commit list (since 0.15.0)`. End the whole
body with the **Full Changelog** compare link on its own line.

A **first release** has no previous tag to compare against. Label the summary
plainly (`Full commit list`) and link the tag's commits instead:
`https://github.com/<owner>/<repo>/commits/<this-tag>`.

## New contributors

If the range includes anyone's first merged contribution, add a
`## 👋 New contributors` section thanking them by handle with the PR. Determine
this from PR authors in the range vs. authors before it; skip the section
entirely if there are none.

## Title

Follow the repo's existing release-title convention:

- If prior releases add a short name after the version
  (e.g. `v0.14.0 – New home`), give this one a 2–4 word themed name too, drawn
  from the headline section.
- If prior releases are just the bare version, keep it bare.

Match the tag's own prefix style in the version part of the title (bare `0.16.0`
vs `v0.16.0`) — the tag-format rule is in `SKILL.md`.
