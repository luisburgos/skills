---
name: deriving-ui-page-blueprints
description: Derive a stack-agnostic page blueprint from a mockup, naming the components it is built from and the data it shows them.
disable-model-invocation: true
---

# Deriving page blueprints

A page is not a large component. A component takes slots from whoever calls
it; a page's parts are fixed and what varies is the data behind them. So a page
blueprint says two things a component blueprint never does: which components it
is built from, and what data it shows them.

A page is named for being a destination with content of its own, not for
filling a display. How it arrives, as a whole screen or a sheet or a dialog, is
a separate question, and the blueprint answers it in its own section.

Steps 1 and 2 are the ones in `deriving-component-blueprints`: read the image
as evidence, and separate what it affirms from what you would assume. Run those
first. What follows replaces that skill's step 3 onward.

## 1. Name every part, and say which already exist

Walk the image top to bottom and name each part, then walk it again for what
floats over the content and the bars around it: those are the parts a walk
through the content misses. Against each one, say whether a component for it
exists, or whether the page will stand a placeholder in its place until one
does.

A placeholder is not debt when the blueprint names what will replace it. It is
debt when the page ships with a box nobody wrote down.

Link a component to its blueprint where one exists. The link is the status: a
component without one has yet to be derived, and a column saying so would only
go stale. A part too small to need a blueprint is marked `(atom)`, so it does
not read as pending.

Parts that appear more than once are one component, not several. Two parts that
merely look alike are two, unless what varies between them is only content.

**Done when:** every part of the image is named, the floating ones included,
and each is linked, marked as an atom, or standing in.

## 2. Draw the layout as the page arranges it

The page owns the arrangement its parts do not: which sit side by side, which
span the width, what separates the groups, what floats above.

Group a run of parts only when the grouping has a rule of its own. Two cards in
a row that must match heights is a group; three cards stacked with the same gap
between them is not, it is the page's own rhythm.

Say that the arrangement illustrates rather than binds. A redesign may reorder
a page without a single component changing, so an arrangement written as a
promise is one a later mockup quietly breaks. What binds is the rules: a group
that matches heights, a bar that floats over the rest.

**Done when:** a reader can rebuild the arrangement from the blueprint without
the image, the arrangement is marked as illustrative, and no group exists that
carries no rule.

## 3. Write the presentation model

The page presents one model of its own, distinct from the domain it draws
from. A habit and its check-ins are the domain; what the page shows is
already counted, formatted and ordered.

The rule that decides every field:

- **Text the reader sees is a string, already formatted.** "46.8", "13 hours
  ago", "7:03 a.m.". The page's model carries the locale, the rounding and
  the separators, so a component never formats and a mock never has to
  reproduce a format to be believable.
- **Numbers only where a component draws with them.** A level per cell, a
  position from zero to one, a point per day. These are geometry, not text.

A number field is a guess until its component is derived: the component's
attributes decide what it draws with. Deriving the component updates this
table in the same change.

Name a field for what the reader sees, not for the query that produced it. A
field whose name is a calculation has put the domain back in.

**Done when:** every part from step 1 can be drawn from the model alone, and a
mock of the model can be written by hand in a few lines.

## 4. Say how the page is presented

A page does not always fill the display. The same composition can arrive as a
whole screen, a sheet that expands, a fixed sheet, or a dialog, and the
mockup usually shows one of them: a drag handle, a dimmed backdrop, a back
affordance.

Say which one the image shows. Say nothing about the others until a mockup asks
for them.

**Done when:** the blueprint names the presentation the image shows.

## 5. Carry the open questions forward

The questions from step 2 of the component skill ship with the page, in their
own section, but only the ones the page itself answers.

A page passes most numbers through: it receives a band and a label and places
them, and how the band behind them was chosen belongs to whoever computed the
pair. Filing that question here makes the page look responsible for something
it only carries.

Drop a question the image already answers elsewhere, and say why. Two counts
that match in one example do not make a rule, and a list that admits several
entries a day settles it without anyone deciding.

**Done when:** every silent item appears in the blueprint or is explicitly
dropped.

## The shape

```markdown
---
page: <PageName>
version: 1
---

# <PageName>

## Intent

What the page is for, in two or three sentences.

## Components

| component | what it shows |
|-----------|---------------|
| [`<Name>`](../components/<name>.md) | <what the reader sees> |
| `<Name>` | <a component not yet derived, so not yet linked> |
| `<Name>` (atom) | <a part too small to need a blueprint> |

## Layout

- the arrangement, top to bottom
- what floats above it, and its measured inset
- the rule any group carries
- the room a part needs from its neighbours, where it cannot shrink

## Data

| field | what it holds | kind |
|-------|---------------|------|
| `<field>` | <what the reader sees> | string |
| `<field>` | <what a component draws with> | number |

## Presentation

- the form the mockup shows

## Open

- ? a question the image does not answer. Assumed: what is implemented until
  something answers it.
```
