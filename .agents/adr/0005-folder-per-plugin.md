# 0005: Group skills in a folder per plugin

**Status:** Accepted

## Context

[0002](./0002-flat-skills-directory.md) kept `skills/` flat, and named when to
revisit it: about a dozen skills, or two clearly different audiences. Both have
arrived. There are fourteen skills, and
[0004](./0004-one-plugin-per-audience.md) ships them as one plugin per
audience. In a flat folder, which plugin carries a skill is visible only in the
manifest.

## Decision

Each plugin's skills live in a folder of their own, and drafts live outside
all of them:

```
skills/
  personal/          luisburgos-skills
    <skill>/SKILL.md
  contributing/      contributing
    <skill>/SKILL.md
drafts/
  <skill>/SKILL.md   ships in no plugin
```

Each plugin's entry in `marketplace.json` points its `skills` at its folder, so
the folder is the one place that decides which plugin carries a skill. A new
plugin's folder takes the plugin's name; `personal/` is named for its audience
because `luisburgos-skills` keeps its older name.

Shipping a draft is moving it into a plugin's folder and adding it to the
README. Moving a skill between plugins is moving it between folders.

## Why not a folder and a list

A folder per plugin with the skills still listed one by one would be two
places that must agree, and nothing checks that they do. It is the same reason
[0001](./0001-ship-as-a-claude-code-plugin.md) kept invocation in one place.

Checked before deciding, in an isolated configuration: with each entry
pointing at its folder, `claude plugin validate . --strict` passes, each plugin
loads only the skills in its folder, and a skill under `drafts/` ships in
neither.

## Consequences

- A skill's path is still not its identity: it is invoked by the name in its
  frontmatter, so a move changes only which plugin carries it.
- `scripts/link-skills.sh` already finds skills at any depth under `skills/`.
  It is extended to link `drafts/` too, so work in progress stays reachable
  locally.

## Revisit when

A skill needs to ship in two plugins. A folder holds it once.
