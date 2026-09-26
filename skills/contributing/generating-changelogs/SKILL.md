---
name: generating-changelogs
description: >
  Generate a release's CHANGELOG.md entry from Conventional Commits with
  conventional-changelog, in the version bump, or set a repository up to do
  so. Use when bumping a version or a build number, adding a changelog to a
  repository, "update the changelog", "generate the changelog", backfilling
  entries for releases already tagged, or when a changelog lists branch
  commits instead of pull requests. Also use in a repository that releases
  several apps with their own tags, such as ios/1.2.0+3. Not the GitHub
  Release page or store copy, which are drafted from this entry.
---

# Generating changelogs

A changelog entry says what a release carried. It is generated, not written:
the history already holds one Conventional Commit per pull request, and the
entry is that history between two release tags, grouped by type. This skill is
the procedure that keeps it so, and the setup it needs.

## 1. Check the history can be read

The generator reads commits on the default branch. It needs **one Conventional
Commit per pull request**, which only a squash merge gives. A merge commit puts
every commit of its branch on the default branch, and the entry lists each
internal step instead of the pull request.

```sh
gh api repos/<owner>/<repo> --jq '{allow_merge_commit, allow_squash_merge, allow_rebase_merge}'
git log --first-parent --merges --oneline -5 <default-branch>
```

- **Squash only, no merge commits in the range:** go on.
- **Merge commits allowed:** stop. Say that pull requests have to be
  squash-merged for the changelog to work, and let the user change the
  setting. Never merge a pull request with `--merge` yourself.
- **Merge commits already in the history:** stop and say what they do to the
  entry. Rewriting the history is the user's decision, never a default.

**Done when:** the range the entry will cover holds one Conventional Commit per
pull request.

## 2. Find the tags and where each changelog lives

- **One artifact per release,** such as a web app or a cross-platform app built
  from one commit: plain tags, `1.2.0`, and one `CHANGELOG.md` at the root.
- **Several apps released on their own,** such as native iOS and Android apps
  in one repository, each with its own build numbers: a tag prefix per app,
  `ios/1.2.0+3`, and a `CHANGELOG.md` per app in that app's folder. A pull
  request counts for an app by the files it changed under that folder, never by
  the scope in its title, which can be missing or wrong. One that changes two
  apps is in both changelogs.

Where the repository records either choice, follow it. Where it records none,
the choice is a decision record of its own; run the `writing-adrs` skill.

**Done when:** the tag pattern and the changelog's path are known.

## 3. Generate the entry in the bump

The entry is written **by the bump, in the bump's pull request or commit,**
beside the new version number, so it is reviewed with it and the tag lands on a
commit that already holds it.

The generator is `conventional-changelog-cli`, installed globally
(`npm install -g conventional-changelog-cli`). Nothing is installed in the
repository: no `node_modules`, and a `package.json` only if the repository
already reads its version from one.

- **Plain tags, version in `package.json`:**
  `conventional-changelog -p <preset> -i CHANGELOG.md -s -r 1`
- **Prefixed tags:** add `-t <prefix> --commit-path <app folder>`, and pass the
  version as context, since there is no `package.json` to read it from: a JSON
  file whose name **ends in `.json`**, holding `{"version": "1.2.0+3"}`, given
  with `-c`.

Keep the preset the repository already uses. For a new setup take
`conventionalcommits`. A prefixed setup with `<version>+<build>` tags starts from
[assets/changelog.config.cjs](assets/changelog.config.cjs), passed with `-n`,
which only reshapes the heading to `1.2.0 (3)` with the local date.

Show the entry before the bump commits it: the same command without `-i` and
`-s` prints it.

**Done when:** the entry is at the top of the changelog, in the bump, and each
line names its pull request.

## 4. Backfill once, if the file is new

For releases already tagged, generate the whole file once with `-r 0` instead
of `-r 1`, and drop the empty block it prints first for commits after the last
tag. From then on the bump adds one entry at a time.

## Gotchas

- **A configuration's `finalizeContext` replaces the core's,** and the core's is
  what finds the previous and current tags. Replace it and the heading loses its
  compare link unless it sets `currentTag`, `previousTag` and `linkCompare`
  itself, as the asset does.
- **The `conventionalcommits` template ends an entry without a blank line,** so
  with `-s` a new entry runs into the one below it. The asset's template is the
  preset's with that line added.
- **Leave the file as the generator writes it.** A title or a paragraph above the
  entries sits where `-s` writes, and the next entry goes above it.
- **Tooling that is not the product is not `feat`.** A change to the release
  script typed `feat` shows up among the product's features; type it `chore` or
  `ci`.
- **The preset lists only features, fixes, performance changes and reverts.**
  Documentation and chores are left out on purpose; an entry that needs them is
  the wrong preset, not a template to patch.

The entry is the source for the pages written from it: the GitHub Release page
is the `drafting-release-notes` skill, and store copy has its own skill where
the repository ships to a store.
