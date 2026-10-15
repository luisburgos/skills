---
name: tca-model
description: >
  The rules for how an app built with The Composable Architecture uses it: where
  state lives, how presentation, preferences, I/O, observation, nondeterminism,
  derivations, views, tests and concurrency are written. Read it before writing,
  changing, reviewing or auditing a feature in a TCA app, and when surrounding
  code and the rules disagree. Reference, no steps; building-tca-features and
  auditing-tca-conformance apply it.
---

# The TCA model

How much of The Composable Architecture an app uses, decided once rather than per
screen. Every rule is grounded in TCA's own documentation, examples or maintainers,
or, where they are silent, in a named engineering principle; the sources are
linked under each rule. Read against TCA 1.26.

A repository adopts these rules through a decision record that cites this skill,
and checks them in CI with the script of `auditing-tca-conformance`. Where a
repository's code and these rules disagree, the rules win: new code follows them,
and the old code is a finding, never a pattern to copy.

**Check** marks what the script catches from one line of Swift. **Audit** marks
what needs judgement, reviewed by `auditing-tca-conformance` before each release.

## T1 Features (audit)

A screen, sheet or popover that has logic, effects or dependencies is a
`@Reducer` with `@ObservableState`, composed with `Scope`, `ifLet` or `forEach`.
Its view gets a store scoped along a stored property, never a computed one. Leaf
components with no logic of their own (rows, pickers, fields, headers) are plain
SwiftUI views taking values, bindings and closures. A list row becomes a reducer
only when it has effects of its own.

TCA belongs "at the level of a complex feature", not on every component
([mbrandonw, #3515](https://github.com/pointfreeco/swift-composable-architecture/discussions/3515#discussioncomment-11422469));
scope "only along stored properties of child features"
([Performance](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/Performance.md?plain=1#L394-L395)).

## T2 Presentation (audit)

A presentation the reducer opens, closes or reacts to (sheet, popover, alert,
confirmation dialog, drill-down) lives in State through `@Presents`, with one
`@Reducer enum Destination` when a feature can present more than one thing. A
presentation with no logic at all, such as a system share sheet, may use view
`@State` under T4.

[Tree-based navigation](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/TreeBasedNavigation.md)
is TCA's tool for it; isowords keeps a share sheet in `@State`.

## T3 Preferences (check)

Device preferences are `@Shared(.appStorage)` with type-safe keys, held in State
when reducer logic reads or writes them; a view that only displays one may
declare `@SharedReader(.appStorage)` itself. SwiftUI `@AppStorage` is not used: it
reads `UserDefaults.standard` directly, past the test and preview defaults that
`@Shared` substitutes
([Sharing state](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/SharingState.md)).

## T4 View state (check)

View `@State` holds only what no reducer logic reads: hover, press, animation
phase, in-flight drag geometry, and a draft bridged to the store. Focus that the
reducer sets lives in State, bridged with `@FocusState` and `.bind`. Each
`@State` carries an `// ephemeral: <reason>` comment saying why the reducer never
needs it, so every exception is visible.

Much view state "is fine to be local to a view"
([Performance](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/Performance.md));
TCA's own focus case study keeps focus in state
([FocusState](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Examples/CaseStudies/SwiftUICaseStudies/01-GettingStarted-FocusState.swift#L14)).
The comment is a house convention.

A text field binds to the store through `BindingReducer` and `@Bindable`
([Bindings](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/Bindings.md)).
`@State` for its text only where sending an action per keystroke has proven
costly, or where the reducer rewrites the text while it is typed.

## T5 I/O (audit)

All I/O goes through a `@Dependency`; new clients are `@DependencyClient`
structs with live, preview and test values. Async or failable I/O runs in
`.run`, with failures turned into actions. Writes made by mutating a `@Shared`
persistence key are the exception, since TCA performs them from the reducer by
design. No synchronous database call inside `Reduce`.

[Dependency management](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/DependencyManagement.md?plain=1#L8-L11).
The ban on synchronous database calls is a house choice, grounded in
[functional core, imperative shell](https://www.destroyallsoftware.com/screencasts/catalog/functional-core-imperative-shell):
a reducer that performs I/O cannot be tested by its state alone.

## T6 Observed data (audit)

Displayed database data is observed, never re-read after a write, and filtered
and sorted in the query rather than in Swift. With plain GRDB: one long-running
`.run` effect, cancellable by id and started by
`.task { await store.send(.task).finish() }`, iterating a client's
`ValueObservation` stream. An app on SQLiteData uses `@FetchAll`, `@FetchOne` or
`@Fetch` in State instead
([Observing](https://github.com/pointfreeco/sqlite-data/blob/1.12.1/Sources/SQLiteData/Documentation.docc/Articles/Observing.md)).

## T7 Nondeterminism (check)

The current date, calendar, time zone, locale, UUIDs and waiting come only from
`@Dependency(\.date.now)`, `\.calendar`, `\.timeZone`, `\.locale`, `\.uuid` and
`\.continuousClock`. Never `Date()`, `Date.now`, `Calendar.current`,
`TimeZone.current`, `Locale.current`, `UUID()` or `Task.sleep` in views, reducers
or State initialisers: generate values in the reducer and pass them in. A
dependency's live implementation reads them with `// tca-allow(T7): <reason>`.
Fixtures and previews may use literals.

TCA lists dates, UUIDs and clocks among the dependencies that make a feature
untestable when used directly
([Dependency management](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/DependencyManagement.md?plain=1#L8-L11)).

## T8 Derivations (audit)

Derived values that logic or tests depend on are computed properties of State, or
the database query itself, defined once for every screen. A leaf view may compute
pure presentation of values it already holds (formatting, a progress ratio) and
nothing that decides behaviour.

Computed properties on State are the documented place; TCA also pushes cheap
display computation "towards the leaf nodes"
([Performance](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/Performance.md)).

## T9 Views (audit)

Views read state and send actions named for what the user did. Every rule
(validate, turn a drop into a change, decide what to save) is in the reducer, so
the action carries the raw payload. A view may adapt a SwiftUI API to an action
(`onEditingChanged`, `.bind`) but decides nothing. Reformatting text while it is
typed is the documented exception: it needs a view-side formatter or a `@State`
bridge.

Actions decouple logic from the view
([FAQ](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/FAQ.md?plain=1#L61));
also [separation of concerns](https://www.cs.utexas.edu/~EWD/transcriptions/EWD04xx/EWD447.html)
and Fowler's [Passive View](https://martinfowler.com/eaaDev/PassiveScreen.html).

## T10 Tests (check, then audit)

Every reducer has `TestStore` tests. Leaf features are tested exhaustively, the
default. `exhaustivity = .off(showSkippedAssertions: true)` is allowed only in
integration tests across features and for state observed from the database,
each with a `// non-exhaustive: <reason>` comment on its line or the one above.
Every behavioural acceptance criterion of a PRD maps to at least one `TestStore`
test; criteria about rendering are checked in the running app.

Non-exhaustive testing is a documented feature for "highly composed features"
([Testing](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/TestingTCA.md));
the check holds the form and the reason, the audit holds the mapping to PRDs.

## T11 Concurrency (check)

Swift 6 language mode, complete checking, `@MainActor` test suites. Features use
async/await, effects and the clock dependency. `DispatchQueue`, locks,
`@unchecked Sendable` and `nonisolated(unsafe)` appear only inside a dependency's
live implementation that wraps a queue-based or non-Sendable API, each marked
`// tca-allow(T11): <the synchronisation that makes it safe>`.

TCA builds in the Swift 6 mode and replaced schedulers with clocks; Swift's
[migration guide](https://github.com/swiftlang/swift-migration-guide/blob/949b5e1be201af4346f60b243e7955bd5849f3f6/Guide.docc/CommonProblems.md)
asks for care with the unchecked escapes.

## Markers

The check skips a line that carries the marker of its rule, so every exception
is written down where it is made and counted by the audit:

| Marker | Rule |
|---|---|
| `// ephemeral: <reason>` | T4 |
| `// tca-allow(T7): <reason>` | T7 |
| `// tca-allow(T11): <reason>` | T11 |
| `// non-exhaustive: <reason>` | T10 |

A marker without a reason a reviewer can check is a breach of its rule.
