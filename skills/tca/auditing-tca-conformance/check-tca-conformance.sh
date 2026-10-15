#!/usr/bin/env bash
# Checks the rules of the TCA norm that a line of Swift can show: T3, T4, T7, T10 and T11.
# The rest (T1, T2, T5, T6, T8, T9) need judgement and are left to the audit.
#
# Usage: check-tca-conformance.sh <root>                  every .swift file under <root>
#        check-tca-conformance.sh <root> --since <ref>    only lines added or changed since <ref>
#        check-tca-conformance.sh --self-test
#
# --since is for a repository still being brought to the norm: no change may add a breach,
# and no baseline file lists the old ones. Once the full check passes, drop --since.
# A file is a test file when its path has a /Tests/ folder or its name ends in Tests.swift.
# Exits 1 when any rule is broken, printing path:line: rule: what to do.
#
# Canonical copy: the auditing-tca-conformance skill of luisburgos/skills. A repository
# vendors it unchanged, so the audit can tell a stale copy by comparing the two.
set -euo pipefail

check() {
  local root=$1
  find "$root" -name '*.swift' \
    -not -path '*/.build/*' -not -path '*/checkouts/*' -not -path '*/DerivedData/*' \
    -not -path '*/.claude/worktrees/*' -print0 |
    xargs -0 awk '
      # The code of a line without its comment, keeping a // that follows a colon,
      # as in a URL. ponytail: misses // inside a string and /* */ comments; a false
      # positive there is silenced with the rule'"'"'s marker.
      function code_of(s,   i, off) {
        off = 0
        while ((i = index(substr(s, off + 1), "//")) > 0) {
          i += off
          if (i > 1 && substr(s, i - 1, 1) == ":") { off = i + 1; continue }
          return substr(s, 1, i - 1)
        }
        return s
      }
      function report(rule, message) { printf "%s:%d: %s: %s\n", FILENAME, FNR, rule, message }

      FNR == 1 { test = (FILENAME ~ /\/Tests\// || FILENAME ~ /Tests\.swift$/); prev = "" }
      {
        line = $0
        code = code_of(line)

        if (!test && code ~ /@AppStorage/)
          report("T3", "@AppStorage: keep the preference in state with @Shared(.appStorage), or display it with @SharedReader")

        if (!test && code ~ /@State[ (]/ && line !~ /\/\/ ephemeral:/)
          report("T4", "@State: move it to the store, or mark what no reducer reads with // ephemeral: <reason>")

        if (!test && line !~ /tca-allow\(T7\)/ &&
            code ~ /(^|[^A-Za-z0-9_.])(Date|UUID)\(\)|Date\.now|Task\.sleep|(Calendar|TimeZone|Locale)\.(current|autoupdatingCurrent)/)
          report("T7", "read now, calendar, time zone, locale, ids or time through @Dependency, or mark a live implementation with // tca-allow(T7): <reason>")

        if (!test && line !~ /tca-allow\(T11\)/ &&
            code ~ /DispatchQueue|@unchecked Sendable|nonisolated\(unsafe\)|NSLock|os_unfair_lock/)
          report("T11", "only inside a dependency'"'"'s live implementation, marked // tca-allow(T11): <how it is synchronised>")

        if (test && code ~ /exhaustivity *=/) {
          if (code !~ /\.off\(showSkippedAssertions: *true\)/)
            report("T10", "a non-exhaustive TestStore uses .off(showSkippedAssertions: true)")
          else if (line !~ /non-exhaustive:/ && prev !~ /non-exhaustive:/)
            report("T10", "say why with // non-exhaustive: <integration test or database-observed state>")
        }
        prev = line
      }
    '
  # Swift 6 language mode in every package.
  find "$root" -name Package.swift -not -path '*/.build/*' -not -path '*/checkouts/*' \
    -not -path '*/.claude/worktrees/*' -print0 |
    xargs -0 grep -n -H -E 'swift-tools-version: *5|swiftLanguage(Modes|Versions): *\[[^]]*\.v5' |
    sed -E 's/^([^:]+:[0-9]+):.*/\1: T11: build the package in the Swift 6 language mode/' || true
}

# Every line added or changed since $2, as /absolute/path:line, untracked files whole.
changed_lines() {
  local top
  top=$(git -C "$1" rev-parse --show-toplevel)
  git -C "$top" diff -U0 --no-color "$2" -- '*.swift' |
    awk -v top="$top" '
      /^\+\+\+ b\// { file = top "/" substr($0, 7); next }
      /^@@/ {
        split($3, range, ",")
        start = substr(range[1], 2); count = (range[2] == "" ? 1 : range[2])
        for (i = 0; i < count; i++) print file ":" start + i
      }'
  git -C "$top" ls-files --others --exclude-standard -- '*.swift' |
    while IFS= read -r file; do awk -v f="$top/$file" '{ print f ":" NR }' "$top/$file"; done
}

run() {
  local root since found
  root=$(cd "$1" && pwd -P)
  since=${2:-}
  found=$(check "$root")
  if [ -n "$since" ] && [ -n "$found" ]; then
    found=$(printf '%s\n' "$found" |
      awk -F': ' 'NR == FNR { changed[$0] = 1; next } ($1 in changed)' <(changed_lines "$root" "$since") - || true)
  fi
  if [ -n "$found" ]; then
    printf '%s\n' "$found"
    echo "$(printf '%s\n' "$found" | wc -l | tr -d ' ') breach(es) of the TCA norm." >&2
    return 1
  fi
  echo "TCA norm: no breach in $root${since:+ since $since}."
}

self_test() {
  local dir expected actual
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' RETURN
  mkdir -p "$dir/Sources" "$dir/Tests"
  cat > "$dir/Sources/Feature.swift" <<'SWIFT'
@AppStorage("x") var x = 1
@State private var hovering = false // ephemeral: hover highlight
@State private var shown = false
let now = Date()
let later = Date(timeIntervalSinceNow: 60)
let id = UUID() // tca-allow(T7): live uuid client
let calendar = Calendar.current
try await Task.sleep(for: .seconds(1))
/// Never call Date() in a view.
let link = "https://example.com" // a URL, not a comment break
DispatchQueue.main.async {}
final class Box: @unchecked Sendable {} // tca-allow(T11): guarded by a lock
SWIFT
  cat > "$dir/Tests/FeatureTests.swift" <<'SWIFT'
store.exhaustivity = .off
// non-exhaustive: state observed from the database
store.exhaustivity = .off(showSkippedAssertions: true)
store.exhaustivity = .off(showSkippedAssertions: true)
let now = Date()
SWIFT
  printf '%s\n' '// swift-tools-version:5.9' > "$dir/Package.swift"

  expected=$(printf '%s\n' \
    'Feature.swift:1: T3' 'Feature.swift:3: T4' 'Feature.swift:4: T7' 'Feature.swift:7: T7' \
    'Feature.swift:8: T7' 'Feature.swift:11: T11' 'FeatureTests.swift:1: T10' 'FeatureTests.swift:4: T10' 'Package.swift:1: T11')
  actual=$(check "$dir" | awk -F': ' '{ n = split($1, path, "/"); print path[n] ": " $2 }' | sort)
  if [ "$actual" != "$(printf '%s\n' "$expected" | sort)" ]; then
    echo "self-test failed. Expected:"; printf '%s\n' "$expected" | sort
    echo "Got:"; printf '%s\n' "$actual"
    return 1
  fi

  # --since reports only what was added after the reference.
  git -C "$dir" init -q && git -C "$dir" add -A &&
    git -C "$dir" -c user.name=t -c user.email=t@t -c commit.gpgsign=false commit -q -m base
  printf '%s\n' '@AppStorage("y") var y = 2' >> "$dir/Sources/Feature.swift"
  printf '%s\n' '@State private var open = false' > "$dir/Sources/New.swift"
  actual=$(run "$dir" HEAD 2>/dev/null | awk -F': ' '{ n = split($1, path, "/"); print path[n] ": " $2 }' | sort || true)
  expected=$(printf '%s\n' 'Feature.swift:13: T3' 'New.swift:1: T4')
  if [ "$actual" != "$expected" ]; then
    echo "self-test of --since failed. Expected:"; printf '%s\n' "$expected"
    echo "Got:"; printf '%s\n' "$actual"
    return 1
  fi
  echo "self-test passed"
}

case "${1:-}" in
  --self-test) self_test ;;
  ""|-h|--help) sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
  *)
    if [ "${2:-}" = "--since" ] && [ -n "${3:-}" ]; then run "$1" "$3"
    elif [ -z "${2:-}" ]; then run "$1"
    else echo "usage: check-tca-conformance.sh <root> [--since <ref>]" >&2; exit 2
    fi ;;
esac
