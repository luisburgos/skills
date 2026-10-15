---
name: building-tca-features
description: >
  Build or change a feature in an app that uses The Composable Architecture, so
  it follows the TCA model rather than the code around it. Use when adding a
  screen, sheet, popover, preference, effect, database read or test to a Swift
  app with a @Reducer, when changing behaviour in one, or when fixing a bug in
  one. Also use when the surrounding code keeps state, presentation or I/O
  outside the store and a new change would follow it.
---

# Building TCA features

A feature is built against the rules of the `tca-model` skill, not against the
file it lands in. Read that skill first, and the repository's TCA decision
record, which may add rules of its own.

The failure this prevents: code that keeps state in views or performs I/O inside
the reducer is copied, feature after feature, because matching the surrounding
code is the usual habit. Here the rules win over the surroundings. Code that
breaks them is left as it is, outside the change, and named as a finding.

## 1. Place the change

Name the feature the change belongs to: the screen, sheet or popover that has
the logic (T1). A change with logic, effects or dependencies that belongs to no
reducer starts one, composed into its parent with `Scope`, `ifLet` or
`forEach`. A leaf view with no logic stays a plain view taking values, bindings
and closures.

**Done when:** the change has a reducer to live in, or is a leaf view with none.

## 2. Write the state and the actions

- What the reducer opens, closes or reacts to is presented from State with
  `@Presents`, one `Destination` enum when there are several (T2).
- Preferences the reducer reads are `@Shared(.appStorage)` in State (T3).
- Focus the reducer sets is in State, bridged with `.bind` (T4). Text fields
  bind through `BindingReducer` (T4).
- Derived values that logic or a test depends on are computed properties of
  State (T8).
- Actions are named for what the user did and carry the raw payload: a drop
  sends what was dropped and where, and the reducer decides what it means (T9).

**Done when:** no value the reducer reads lives in a view.

## 3. Write the effects

- I/O goes through a `@Dependency`; a new client is a `@DependencyClient` with
  live, preview and test values (T5).
- Async or failable I/O runs in `.run` and returns its result or failure as an
  action. No synchronous database call inside `Reduce` (T5).
- Displayed data is observed by one long-running, cancellable effect, started
  from the view's `.task`, and filtered and sorted in the query (T6).
- The date, calendar, time zone, locale, ids and waiting come from dependencies,
  read in the reducer and passed into State (T7).

**Done when:** the reducer, given its state and an action, touches nothing
outside itself.

## 4. Write the view

The view reads state and sends actions (T9). `@State` holds only what no
reducer logic reads, each with its `// ephemeral:` reason (T4). Formatting and
pure display values may be computed here; decisions may not (T8).

**Done when:** deleting the view would lose no rule of the feature.

## 5. Write the tests

A `TestStore` test for each behaviour, exhaustive for a leaf feature, with every
dependency it reaches overridden (T10). Non-exhaustive only for an integration
test across features or for state observed from the database, written
`.off(showSkippedAssertions: true)` with its `// non-exhaustive:` reason. Each
behavioural acceptance criterion of the PRD the change builds names the test that
holds it.

**Done when:** each new behaviour has a test that fails when the behaviour is
undone. Undo it once and watch the test fail; a test never seen failing proves
nothing.

## 6. Run the check

Run the repository's copy of `check-tca-conformance.sh` (from the
`auditing-tca-conformance` skill, usually vendored in `tools/`) on the app's
folder. A breach in the lines the change touched is fixed before the change is
proposed. A breach in lines it did not touch is reported in the pull request as
a finding, not fixed in passing.

**Done when:** the check reports no breach in the change's own lines.
