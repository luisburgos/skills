---
name: writing-pull-requests
description: >
  Write or rewrite a pull request description, and check first that the change
  is one pull request rather than several. Use when opening a pull request,
  filling in a pull request template, splitting a change into pull requests,
  or reviewing a description before it goes out. Also use when a repository
  has no pull request template yet and needs one.
---

# Writing pull requests

The diff is one click away and says what changed. A description earns its
place by carrying what the diff cannot: what was deliberately left alone, what
went unverified, and where to push back.

An agent-authored description fails the same way every time: it narrates the
session that produced the change instead of stating what a reviewer must act
on. The register below exists to stop that.

## 1. Check the change is one pull request

A pull request does one thing. A description that needs "and also" is two
pull requests.

- A change to a document the code implements (a spec, a requirements document,
  a glossary, a contract) is its own pull request, merged before the code.
- A refactor changes no behaviour; a fix or a feature goes separately.
- Removing what is no longer used comes before adding what replaces it.
- Two pull requests that change the same lines are not open at once: the
  second waits for the first to merge.

The repository's own agent instructions (`AGENTS.md`, `CLAUDE.md`) may order
these more precisely, and where they do, they win.

**Done when:** the change does one thing, and anything it depends on has
merged or is its own pull request.

## 2. Find the template

The repository's template wins, whatever its sections:
`.github/pull_request_template.md`, or a variant under `.github/` or `docs/`.

With none, offer to copy this skill's
[assets/pull_request_template.md](assets/pull_request_template.md) into the
repository's `.github/`. Adding it is a change of its own, so it is its own
pull request, and it waits for the user's yes.

**Done when:** the description has a template to follow.

## 3. Fill it in the register

- **Delete every template comment,** and delete any section with nothing to
  say rather than padding it.
- **One continuous line per paragraph and per bullet.** The renderer reflows
  it; a hard wrap shows as text snapping to a narrow column.
- **No session narration.** "Writing this still produced something three
  times longer" tells a story from the authoring session. State the fact.
- **No evolution of the pull request itself.** What changed between drafts a
  reviewer never saw is not their concern.
- **Each description is read alone.** "First of three", "as decided in #2".
  The one exception is a base branch other than the default, which a reviewer
  needs to read the diff.
- **A cross-reference to another pull request is almost always narration.**
  Check it against that exception before keeping it.
- **Purpose, not provenance.** Say what a rule prevents, not where it came
  from.
- **No defending your own edits** against an imagined objection.
- **No second person.** "Your call" belongs nowhere; review focus is stated as
  a fact.
- **Bullets, not bolded paragraphs,** for the reasons and the evidence.
- **Evidence names what was run,** and leads what was not with
  `**Not verified:**`. That line is most useful when the news is bad, which is
  when it gets left out.
- **Nothing outside the repository is evidence.** Other repositories, private
  notes and the conversation are invisible to a reader. State the substance
  instead.

The repository may record failures caught in its own reviews in its agent
instructions. Read them before writing: a mistake made there once is the one
most likely to be made again.

**Done when:** every template comment is gone, no section restates the diff,
the evidence names at least one thing that was not verified, and the review
focus makes sense to someone who has read no other pull request in the
repository.
