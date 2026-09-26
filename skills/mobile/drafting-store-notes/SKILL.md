---
name: drafting-store-notes
description: >
  Draft the store copy for a mobile release: the Google Play release notes
  (en-US and es-419 by default, 500 characters each) and the TestFlight "What
  to Test" text, from the release's CHANGELOG.md entry, approved in
  conversation before any file is written. Use when "generate the store
  notes", "draft the listing notes for this build", "write the Play notes",
  "what's new for TestFlight", or a release runbook's store-notes step. Works
  for any mobile stack that ships to Google Play or TestFlight. Not the GitHub
  Release page, which is a different document for a different reader.
---

# Drafting store notes

Store notes generated from raw commit subjects are compliant and useless: they
do not tell a tester or a store reviewer what changed. The release's
`CHANGELOG.md` entry already holds the material, grouped into features and
fixes; this skill turns it into copy a person reads, within the store's limit,
and writes nothing until the user approves it.

It drafts and writes local text files only. Uploading is the release
pipeline's job.

## 1. Gather the inputs

Ask for whichever is not already clear, rather than guessing:

1. **The changelog entry.** Usually the newest entry in `CHANGELOG.md`, the
   release being shipped. A re-cut candidate may want only what changed since
   the last one: ask. Where the repository has no generated entry yet, run the
   `generating-changelogs` skill first.
2. **Where the two files land.** A Play notes file and a What's-New file. When
   the release script or lane names the paths, printed or passed in, use those
   verbatim; never rebuild a path from memory of a constant seen once. With no
   convention, default to a visible top-level `releases/` folder:
   `releases/stores-listing-notes-<version>-build<N>.txt` and
   `releases/whats-new-<version>-build<N>.txt`, keyed by build number so a
   re-uploaded build keeps its own notes. Not `release-notes-…`, which names
   the GitHub Release document.
   **List the directory before writing.** A release flow that has shipped
   before almost always has earlier files there; an empty or missing directory
   on a repository that has released before means the path is wrong, so stop
   and re-derive it.
3. **Locales.** `en-US` and `es-419` unless the store listing says otherwise.
   Latin American Spanish is `es-419`: `es-MX` is not a Play Console locale and
   the Play Developer API rejects it at upload.

**Done when:** the entry, both paths and the locales are known.

## 2. Draft the Play notes

Play allows **500 characters per locale**, so a real commit list does not fit.
Pick one or two **headline items**, the change a user would notice, and write
around them; put anything secondary under "Also in this release:" as a plain
list. A short, accurate headline beats a cramped exhaustive list.

Short, concrete sentences about what changed for the user, never the internal
mechanism. **Omit the justification**: state what changed, not why it is
better. The user sees the result; the reason is dead weight and usually the
longest clause. Cut `so that…` and `para que…` at draft time:

> ❌ "with the account name on its own line **so longer names stay readable**"
> ✅ "with the account name on its own line"

One such cut has taken a headline from 137 to about 105 characters in both
locales, which is the difference between no room to edit and real headroom.

The second locale is a **full translation**, not a shorter summary.

**en-US, ≤500 characters:**
```
Redesigned route destinations: a new map and timeline that are clearer and
color-coded by stop status (completed, in progress, or pending).

Also in this release:
- Your unit's live position now always shows above the route line on the map.
- Route history now groups start and end times more clearly by day.
- Fixed event markers still appearing after turning off the filter.
```

**es-419, ≤500 characters:**
```
Rediseñamos los destinos de ruta: nuevo mapa y línea de tiempo más claros,
con colores según el estado de cada parada (completada, en curso o
pendiente).

También en esta versión:
- La posición en vivo de tu unidad ahora siempre se ve por encima de la
  línea de ruta.
- El historial de rutas agrupa mejor las horas por día.
- Corregimos que los marcadores de eventos siguieran apareciendo tras
  desactivar el filtro.
```

Count characters for real before presenting, never by estimate:

```sh
printf '%s' "<draft text>" | wc -c
```

Over budget, cut secondary items before touching the headline. A headline still
too long is usually carrying a justification clause.

**Done when:** both locales are within 500 characters, counted.

## 3. Get the copy approved

Present both locales in the conversation, labelled, with their counts. Write no
file. Apply the user's edits and **recount after every edit**: a small change
can push a locale over.

**Done when:** the user approves the copy in words.

## 4. Write both files

The Play notes file uses Play's submission template, one block per locale, with
multi-line bodies kept as they are:

```
<en-US>
<approved en-US text>
</en-US>

<es-419>
<approved es-419 text>
</es-419>
```

**TestFlight is not drafted.** Its What's-New file is one approved Play
locale's body, verbatim, with no tags and no "what to test" framing added: the
Play note is the TestFlight note. Pick the locale the testers read, and write it
straight from the approved copy; it needs no approval of its own.

Confirm both writes with their exact paths, so the next step of the release can
pick them up.

**Done when:** both files exist at the paths from step 1, holding the approved
copy.

## Gotchas

- **Already-final copy** needs only steps 3 and 4: validate the counts, get the
  word, write.
- **The approved copy is the copy.** Later stages of the release reuse it
  verbatim; they derive from it, they do not improve it.
