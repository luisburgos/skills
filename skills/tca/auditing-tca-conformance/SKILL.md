---
name: auditing-tca-conformance
description: >
  Audit an app built with The Composable Architecture against the TCA model, and
  adopt the model's check in a repository. Use before cutting a release of a TCA
  app, when asked whether an app or a branch follows its architecture, when
  bringing a repository under the TCA model, or when the check script fails and
  its breaches need sorting. Carries check-tca-conformance.sh, the script a
  repository vendors and runs in CI and before a push.
---

# Auditing TCA conformance

An audit holds an app to the rules of the `tca-model` skill: the script catches
what one line shows, and this procedure covers what needs judgement. It reports;
it does not fix. Read `tca-model` first.

## Adopting the check in a repository

Once per repository, as its own pull request:

1. Copy [`check-tca-conformance.sh`](check-tca-conformance.sh) unchanged to the
   repository's `tools/`, executable, and run `tools/check-tca-conformance.sh
   --self-test`. Copy the rules of `tca-model`, without its frontmatter, as a file
   of the repository where it keeps its architecture, such as
   `docs/architecture/tca.md`, so every rule and `T` number resolves inside it.
2. Run it in CI on the app's folder, and in the pre-push hook. While the app
   still has breaches, both run with `--since origin/<default branch>`, so no
   change adds one; no baseline file lists the old ones. When the full check
   passes, `--since` is dropped.
3. The repository's decision record for TCA adopts that file as the rules it
   follows, stating why in its own words rather than by pointing outside the
   repository. Where the record it supersedes, or the code's own comments, say
   the opposite (views own sheets, the reducer re-reads), it says so and replaces
   them. Its *Confirmation* is the check passing and the audit finding nothing
   High.

**Done when:** a pull request that adds an `@AppStorage` fails CI.

## 1. Check the copy is current

Compare the repository's copies of the script and the rules with the ones
beside these skills. A copy that differs, unless the difference is recorded in
the repository's decision record, is a finding of its own: the rules moved and
the repository did not.

With no copy at all, say so and run the script beside this skill. The repository
has not adopted the rules, so step 4 ranks the findings, but nothing blocks a
release.

**Done when:** the copies match, the difference is a finding, or the absence is
stated.

## 2. Run the check in full

Run the copy on the app's folder without `--since`, even where CI uses it, so
the audit counts every breach rather than only new ones. Then run it with
`--since <the tag of the last release before the one being audited>`: before
tagging, the latest tag; after, the one before it. `--since` reads lines, so a
line that only moved shows as new: check each hit with `git blame -M -C` or
`git log -L <line>,<line>:<file> <tag>..HEAD`, and treat a moved line as old.

List every marker (`// ephemeral:`, `// tca-allow(T7):`, `// tca-allow(T11):`,
`// non-exhaustive:`) and read its reason. A reason a reviewer cannot check, or
that describes something the reducer does read, is a breach of its rule.

**Done when:** every breach and every marker is listed by rule.

## 3. Review what needs judgement

For each reducer, and each view that holds a store, `@State`, `@AppStorage` or
a closure that sends an action (a view that only takes values needs no reading):

- **T1:** a view with logic, effects or dependencies and no reducer of its own;
  a store scoped along a computed property; a leaf view handed a whole store.
- **T2:** a sheet, popover, alert or dialog whose opening or closing the reducer
  would need to know, presented from view state.
- **T5:** `try` or a dependency call inside `Reduce` that is not in `.run`; I/O
  performed in a view; a client that is not a `@Dependency`.
- **T6:** a re-read of the database after a write; filtering or sorting in Swift
  of data a query could order; an observation with no cancellation.
- **T8:** a value decided in a view that a test or another screen depends on;
  the same derivation written twice.
- **T9:** a view that decides (validates, converts a drop, chooses what to save)
  rather than sending the raw event.
- **T10:** each behavioural acceptance criterion of the PRDs the app builds,
  meaning one that says what is stored, decided, refused or defaulted, not one
  about layout, look, keys or gestures; and the test that holds it: a
  `TestStore` test, a test that calls a client or a derivation directly, or
  none. When one design choice leaves several criteria untestable, such as
  preferences in `@AppStorage`, record the cause once under its rule and list
  the criteria under it.

Each finding names the rule, the file and line, and the smallest snippet that
proves it.

**Done when:** every reducer and view has been read against T1, T2, T5, T6, T8
and T9, and every behavioural criterion has its test or its gap.

## 4. Rank the findings

- **High:** a breach whose code entered since the previous release; a T5 or T6
  breach with a concrete path to lost or stale data, named in the finding; a
  behavioural criterion that entered since the previous release with no test of
  any kind. A High finding blocks the release of a repository that has adopted
  the rules.
- **Medium:** an older breach in code the coming work will change, meaning the
  issues ready to build and the next PRD; an older criterion with no test of any
  kind.
- **Low:** an older breach in code nothing is about to touch, and a criterion
  held only by a test that goes around the reducer.

**Done when:** every finding has a rank and a reason for it.

## 5. Write the audit down

Where the repository keeps its audits; if it names no place, say so and keep it
beside its decision records. Put the High findings where the repository tracks
what blocks a release, as a checklist in its feedback or tracking issue, and
open an issue per finding only where that is the repository's practice. Lead
with the counts by rule, then the High findings, then the rest.

When the audit is the backlog of bringing a repository to the rules, end it with
the findings grouped into slices, each one feature or one rule, small enough for
one pull request that changes no behaviour, in the order they are safest to do:
the tests that hold today's behaviour first.

**Done when:** each High finding is where the release will see it, and a backlog
audit ends in ordered slices.
