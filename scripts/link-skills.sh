#!/usr/bin/env bash
set -euo pipefail

# Links every skill in this repo into the local Claude Code skill directory
# (~/.claude/skills). Each entry is a symlink into this repo, so a `git pull`
# keeps installed skills current.
#
# Re-run after adding, removing, or renaming a skill.
#
# This links EVERY skill in the tree, drafts/ included: local development wants
# reach to work in progress. What ships to other people is decided by which
# plugin's folder under skills/ a skill sits in, not by this script.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.claude/skills"

# If $DEST is a symlink resolving back into this repo, the per-skill symlinks
# below would be written into the repo's own skills/ tree. Bail out rather than
# pollute the working copy.
if [ -L "$DEST" ]; then
  resolved="$(readlink -f "$DEST")"
  case "$resolved" in
    "$REPO" | "$REPO"/*)
      echo "error: $DEST is a symlink into this repo ($resolved)." >&2
      echo "Remove it (rm \"$DEST\") and re-run; it will be recreated as a real dir." >&2
      exit 1
      ;;
  esac
fi

mkdir -p "$DEST"

linked=0
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  target="$DEST/$name"

  # A real directory here is a loose skill that would shadow this repo's copy.
  # Refuse rather than delete someone's unversioned work.
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "error: $target exists and is not a symlink." >&2
    echo "It is a loose skill that would conflict. Move or remove it, then re-run." >&2
    exit 1
  fi

  ln -sfn "$src" "$target"
  echo "linked $name"
  linked=$((linked + 1))
done < <(find "$REPO/skills" "$REPO/drafts" -name SKILL.md -not -path '*/node_modules/*' -print0 2>/dev/null)

if [ "$linked" -eq 0 ]; then
  echo "no skills found under $REPO/skills or $REPO/drafts, nothing to link"
else
  echo "$linked skill(s) linked into $DEST"
fi
