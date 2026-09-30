---
name: auditing-ui-blueprint-implementations
description: Audit an existing component or page implementation against its blueprint, and report each gap with where its fix starts.
disable-model-invocation: true
---

# Auditing blueprint implementations

An audit reads a blueprint as a list of claims and checks each against one
implementation. It reports; it does not fix.

A component and a page are audited the same way. A page adds the checks in
step 4.

## 1. List the claims

Every line of Layout, Behaviour and Accessibility is a claim, and so is every
measured value in Notes. The blueprint's shape is the one in
`deriving-component-blueprints` and `deriving-ui-page-blueprints`.

With no blueprint, derive one first. An audit never invents the contract.

**Done when:** every claim is listed once.

## 2. Give each claim a verdict

- **tested:** a test fails when the rule is undone. Undo it and run the test
  to know; a test never seen failing proves nothing.
- **inspected:** held, but checked only by eye, in a preview or on a device.
  Say why no test can check it.
- **broken:** the implementation does otherwise.
- **missing:** nothing implements it.

Check at the largest text size as well as the default.

**Done when:** every claim has a verdict and its evidence.

## 3. Read the implementation back

List what the implementation does that no claim asks for: a parameter the
Intent refuses, a slot the shell inspects, a size not measured, a placeholder
nobody wrote down.

**Done when:** every such part is listed or traced to a claim.

## 4. For a page, check what only a page holds

- every component in its table is placed, and no placeholder remains for one
  that has a blueprint
- the layout's rules hold: groups, what floats, its inset
- the presentation model has every field in the Data table, of its kind
- the presentation is the one the blueprint names

## 5. Say where each gap's fix starts

- **blueprint:** the contract is wrong or silent, as a measurement one target
  needed and the blueprint never recorded
- **target:** the implementation is wrong
- **idiom:** a difference the stack expresses its own way and that is
  accepted. It is listed under Idiom in the target's README, and an audit
  skips what is listed there

A blueprint gap is checked against every other target: they share the
contract, so they may share the gap.

**Done when:** every gap has one place, and each blueprint gap names the
targets it reaches.

## 6. Write the audit down

An audit is a record of one commit, so it is never edited. A new audit is a
new file.

- **Where:** the repo says where blueprint audits live, in its README,
  CLAUDE.md or AGENTS.md. If none says, ask once, suggest `audits/blueprints/`,
  and add the line to the README so the next audit finds it.
- **One file per audit,** holding every unit it covered: a page and its
  components are one audit.
- **Named** `YYYY-MM-DD-<scope>-<target>-<sha>.md`, with the audited commit's
  short hash. Two audits of one commit, scope and target would say the same.
- **Compared:** when an earlier audit of the same scope and target exists, the
  new one opens with what changed since it.

**Done when:** the file exists where the repo says, and nothing earlier was
edited.

## The report

```markdown
---
audit: blueprint-implementation
date: YYYY-MM-DD
commit: <sha>
target: <target>
scope: <page or component>
blueprints:
  <name>: <version>
---

# Audit: <scope>, <target>

## Since <earlier audit's file name>

- fixed: <claim>
- regressed: <claim>
- new: <claim>

## <Name>

| claim | verdict | evidence |
|-------|---------|----------|
| <the blueprint's line> | tested | <test name> |

Gaps:

- <what>. Starts in: blueprint | target | idiom. Reaches: <targets>
```

The frontmatter lets the file identify itself among other audits in a shared
folder. The "Since" section is left out of a first audit.
