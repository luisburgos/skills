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

# The TCA rules

How much of The Composable Architecture an app uses, decided once rather than per
screen. Each rule says what it requires and why, in its own terms. The links
under a rule are further reading: TCA's documentation, examples and maintainers
agree with it, or, where they are silent, the engineering principle it applies.
Read against TCA 1.26.

A repository adopts these rules through a decision record of its own and keeps
this text as a file of the repository, beside `check-tca-conformance.sh`, the
script that checks the rules one line can show. Once adopted, where the
repository's code and these rules disagree, the rules win: new code follows
them, and the old code is a finding, never a pattern to copy.

**Check** marks what the script catches. **Audit** marks what needs judgement,
reviewed before each release.

## T1 Features (audit)

A screen, sheet or popover that has logic, effects or dependencies is a
`@Reducer` with `@ObservableState`, composed with `Scope`, `ifLet` or `forEach`.
Its view gets a store scoped along a stored property, never a computed one. Leaf
components with no logic of their own (rows, pickers, fields, headers) are plain
SwiftUI views taking values, bindings and closures. A list row becomes a reducer
only when it has effects of its own.

**Why:** a reducer is what makes behaviour testable as state and actions, so
every piece of behaviour needs one, and nothing without behaviour pays for one.
A view handed only its own feature's store knows nothing of the rest of the app
(the Law of Demeter), and scoping along a stored property is what keeps a change
elsewhere from redrawing it.

Further reading: [mbrandonw on where TCA belongs](https://github.com/pointfreeco/swift-composable-architecture/discussions/3515#discussioncomment-11422469);
[Performance, on scoping](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/Performance.md?plain=1#L394-L395).

## T2 Presentation (audit)

A presentation the reducer opens, closes or reacts to (sheet, popover, alert,
confirmation dialog, drill-down) lives in State through `@Presents`, with one
`@Reducer enum Destination` when a feature can present more than one thing. A
presentation with no logic at all, such as a system share sheet, may use view
`@State` under T4.

**Why:** when what is open is state, a test can open it, act in it and see it
close, and the reducer can close it after saving. Held by the view, all of that
is out of reach of any test.

Further reading: [Tree-based navigation](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/TreeBasedNavigation.md).

## T3 Preferences (check)

Device preferences are `@Shared(.appStorage)` with type-safe keys, held in State
when reducer logic reads or writes them; a view that only displays one may
declare `@SharedReader(.appStorage)` itself. SwiftUI `@AppStorage` is not used.

**Why:** `@AppStorage` reads the real user defaults wherever it runs, so a test
or a preview cannot give it a value of its own, and a reducer cannot see it.
`@Shared` is substituted with private defaults in tests and previews, and is
state the reducer reads and writes.

Further reading: [Sharing state](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/SharingState.md).

## T4 View state (check)

View `@State` holds only what no reducer logic reads: hover, press, animation
phase, in-flight drag geometry, a monitor's handle, and the open flag of a
popover that only displays. Focus that the reducer sets lives in State, bridged
with `@FocusState` and `.bind`. Each `@State` carries an
`// ephemeral: <reason>` comment saying why the reducer never needs it, so every
exception is visible.

A field's text binds to the store through `BindingReducer` and `@Bindable`. A
sheet may instead hold its fields in `@State` and send one finished value only
when sending an action per keystroke has been measured as costly, or when the
reducer rewrites the text as it is typed; the `// ephemeral:` reason names which.

**Why:** state the reducer never reads costs nothing to keep in the view, and
moving it would only add actions no test needs. State the reducer does read is
behaviour, and behaviour in a view cannot be tested. The comment makes the line
between the two a written claim a reviewer can check.

Further reading: [Performance, on local state](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/Performance.md);
[the FocusState case study](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Examples/CaseStudies/SwiftUICaseStudies/01-GettingStarted-FocusState.swift#L14);
[Bindings](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/Bindings.md).

## T5 I/O (audit)

All I/O goes through a `@Dependency`; new clients are `@DependencyClient`
structs with live, preview and test values. Async or failable I/O runs in
`.run`, with failures turned into actions. Writes made by mutating a `@Shared`
persistence key are the exception, since TCA performs them from the reducer by
design. No synchronous database call inside `Reduce`.

**Why:** a dependency is the seam a test or a preview replaces. A reducer that
only changes state and returns effects can be tested from its state alone,
while one that performs I/O inline cannot, and blocks the main thread while it
does (functional core, imperative shell).

Further reading: [Dependency management](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/DependencyManagement.md?plain=1#L8-L11);
[Functional core, imperative shell](https://www.destroyallsoftware.com/screencasts/catalog/functional-core-imperative-shell).

## T6 Observed data (audit)

Displayed database data is observed, never re-read after a write, and ordered
and filtered by its own table in the query rather than in Swift; a derivation
across records is a computed property of State (T8). With plain GRDB: one
long-running `.run` effect, cancellable by id and started by
`.task { await store.send(.task).finish() }`, iterating a client's
`ValueObservation` stream. An app on SQLiteData uses `@FetchAll`, `@FetchOne` or
`@Fetch` in State instead.

**Why:** a read after each write shows only the app's own changes; anything else
that writes, a sync, an import or a second window, stays invisible until the next
click. Observing the query shows every change, from wherever it comes.

Further reading: [Observing, in SQLiteData](https://github.com/pointfreeco/sqlite-data/blob/1.12.1/Sources/SQLiteData/Documentation.docc/Articles/Observing.md).

## T7 Nondeterminism (check)

The current date, calendar, time zone, locale, UUIDs and waiting come only from
`@Dependency(\.date.now)`, `\.calendar`, `\.timeZone`, `\.locale`, `\.uuid` and
`\.continuousClock`. Never `Date()`, `Date.now`, `Calendar.current`,
`TimeZone.current`, `Locale.current`, `UUID()` or `Task.sleep` in views, reducers
or State initialisers: generate values in the reducer and pass them in. A
dependency's live implementation reads them with `// tca-allow(T7): <reason>`.
Fixtures and previews may use literals.

A view may read the clock for timing no reducer reads, such as a debounce or the
moment a popover closed, marked `// tca-allow(T7): <reason>`. A view formats with
the locale and calendar of its environment (`@Environment(\.locale)`,
`@Environment(\.calendar)`), set once from the store, never with `.current`.

**Why:** a test cannot hold what a feature does with the time, the calendar or
an id that the feature reads for itself. Through a dependency, each is a value
the test sets.

Further reading: [Dependency management](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/DependencyManagement.md?plain=1#L8-L11).

## T8 Derivations (audit)

Derived values that logic or tests depend on are computed properties of State, or
the database query itself, defined once for every screen. A leaf view may compute
pure presentation of values it already holds (formatting, a progress ratio) and
nothing that decides behaviour.

**Why:** a derivation written once cannot disagree with itself, and on State a
test reaches it. Computed again by each screen, two screens can show two answers.

Further reading: [Performance, on computation](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/Performance.md).

## T9 Views (audit)

Views read state and send actions named for what the user did. Every rule
(validate, turn a drop into a change, decide what to save) is in the reducer, so
the action carries the raw payload. A view may adapt a SwiftUI API to an action
(`onEditingChanged`, `.bind`) but decides nothing. Reformatting text while it is
typed is the known exception: it needs a view-side formatter or a `@State`
bridge.

**Why:** a decision made in a view is behaviour no test reaches. Sent raw, the
event's meaning is decided where it can be tested, and the view stays something
to look at (separation of concerns; a passive view).

Further reading: [FAQ](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/FAQ.md?plain=1#L61);
[Passive View](https://martinfowler.com/eaaDev/PassiveScreen.html).

## T10 Tests (check, then audit)

Every reducer has `TestStore` tests. Leaf features are tested exhaustively, the
default. `exhaustivity = .off(showSkippedAssertions: true)` is allowed only in
integration tests across features and for state observed from the database,
each with a `// non-exhaustive: <reason>` comment on its line or the one above.
A reducer whose state is re-read from the database rather than observed does not
qualify: give its client deterministic ids and dates, and test it exhaustively.
Every behavioural acceptance criterion of a PRD maps to at least one `TestStore`
test; criteria about rendering are checked in the running app.

**Why:** an exhaustive test fails on any change of state it did not expect, so
it holds behaviour nobody thought to assert. Across composed features, and for
state the database owns, asserting everything costs more than it catches, and
the reason comment keeps that a written exception rather than a habit.

Further reading: [Testing, non-exhaustive](https://github.com/pointfreeco/swift-composable-architecture/blob/1.26.2/Sources/ComposableArchitecture/Documentation.docc/Articles/TestingTCA.md).

## T11 Concurrency (check)

Swift 6 language mode in every package and project, complete checking, and
`@MainActor` on every test that builds a `TestStore`, by suite or by function.
Features use async/await, effects and the clock dependency. `DispatchQueue`,
locks, `@unchecked Sendable` and `nonisolated(unsafe)` appear only inside a
dependency's live implementation that wraps a queue-based or non-Sendable API,
each marked `// tca-allow(T11): <the synchronisation that makes it safe>`.

**Why:** the compiler proves the absence of data races only where nothing opts
out of its checking. Each opt-out is a claim the compiler no longer checks, so it
stays at the one boundary that needs it, with the claim written down.

Further reading: [the Swift 6 migration guide](https://github.com/swiftlang/swift-migration-guide/blob/949b5e1be201af4346f60b243e7955bd5849f3f6/Guide.docc/CommonProblems.md).

## Markers

The check skips a line that carries the marker of its rule, so every exception
is written down where it is made and counted by the audit:

| Marker | Rule |
|---|---|
| `// ephemeral: <reason>` | T4 |
| `// tca-allow(T7): <reason>` | T7 |
| `// tca-allow(T11): <reason>` | T11 |
| `// non-exhaustive: <reason>` | T10 |

A marker without a reason, or with one a reviewer cannot check, is a breach of
its rule; the check refuses an empty one.
