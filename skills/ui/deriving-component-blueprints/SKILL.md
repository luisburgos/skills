---
name: deriving-component-blueprints
description: Derive a stack-agnostic component blueprint from a mockup or from existing code.
disable-model-invocation: true
---

# Deriving component blueprints

A mockup is **evidence**, not a specification. It affirms some things, stays
silent on others, and the gap between the two is where a component goes wrong.

The output is a **blueprint**: which components exist, what each owns, and what
the image left open. No code, no framework. Implementation comes after, and the
blueprint is what it implements.

## 1. Split what the image affirms from what you would assume

Two lists, written down.

**Affirms:** the repeated shapes, which instances carry an affordance and which
do not, what changes between instances.

**Silent:** every question the image does not answer. Counting cells in an
image is not a measurement. A value seen once is not a range. Two numbers that
happen to match are not proven equal. The image shows one text size, so what
happens at a larger one is always silent.

The silent list ships with the blueprint as open questions. A default answer
is invisible later and indistinguishable from a decision.

**Measure, do not estimate.** Read sizes, gaps and colours from the image's
pixels at its scale (at 3x, points are pixels over three). Record each measured
value a rule depends on, and the values it depends on in turn: sixteen weeks
fit only beside 11 point labels, so both are recorded.

**Done when:** every repeated shape sits in one list, no silent item has been
quietly answered, and every size the blueprint relies on was measured.

## 2. Rank the candidates by how much is identical

A shape repeating three times is a candidate, not a component. For each, split
what varies from what is identical, and rank by the size of the identical part.

Promote where the identical part is real structure (layout, ordering, spacing)
and the varying part is content. Reject where the only thing shared is a trait
("both have an icon"), and reject what the target framework already provides.

Most candidates are rejections. Record each with its reason in a line: an
unrecorded rejection is a component nobody asked for.

**Done when:** each candidate is promoted or rejected with its reason.

## 3. Cut the seam: the shell owns structure, the caller owns content

Each promoted candidate becomes a **shell** that guarantees structure and
nothing about what fills it. What varies arrives as a **slot**.

Three rules, each earned by a way the cut goes wrong:

- **The shell never decides for the slot.** When instances differ in how they
  align or size their content, that is the slot's business. A shell parameter
  for it is the shell deciding.
- **Absence is nothing, not an empty placeholder.** An affordance that is not
  there leaves no element behind. Two mechanisms for one absence means one is
  unreachable.
- **The shell never inspects its slot.** Matching on what the slot contains in
  order to style it stops treating it as a slot.

Style every slot shares belongs on the shell, stated once. Restated per slot
it duplicates a *decision*, and nothing fails when a copy is forgotten.

**Done when:** each shell's parts are named, and every instance from the image
passes through its shell without a part added for just one of them.

## 4. Name what varies, in the vocabulary of the thing

The blueprint says what each part *is*, not what type a framework would give
it: "the sender's name", "the affordance that dismisses it", "the content,
which aligns itself."

A part named after a framework type stops the blueprint being something two
stacks can implement.

**Done when:** no part's name mentions a framework type, and a reader who knows
neither stack can tell what each part holds.

## 5. Write the blueprint

One document per promoted candidate, in this shape:

```markdown
---
component: <ComponentName>
version: 1
---

# <ComponentName>

## Intent

What the component is, in two or three sentences, and what it refuses to do.
The refusals matter more than the description: they are what stops whoever
implements this from inventing a parameter the cut deliberately left out.

## Attributes

| attribute | description                                            |
|-----------|--------------------------------------------------------|
| <name>    | what it holds, in the vocabulary of the thing          |
| <name>?   | the trailing mark says the component works without it  |

## Layout

- where each attribute sits relative to the others
- what the component does with the space it is offered
- which sizes it keeps and which grow with the text size
- who yields when there is not enough, at the largest text size too

## Behaviour

- what each attribute does that its position does not already say
- what happens when an optional attribute is absent, or past its range
- what a reader can act on, and what that produces

## Accessibility

- what is read, and what is not
- facts about the component that assistive technology or a platform guideline
  would hold it to, and only those you have measured

## Notes

- **What a decision was.** The reason it went that way, not the reasoning that
  got there.
- **What was measured.** The value, and any other value it depends on.

## Open

- ? a question the image does not answer. Assumed: what is implemented until
  something answers it.
```

Rules the shape enforces:

- **A trailing `?` marks an optional attribute.** Optional is the exception, so
  a column of "required: yes" would be noise. The mark already means this in
  every stack that will implement it.
- **Requirements, never mechanisms.** "Surfaces the explanation in a popup" is
  a requirement each stack satisfies its own way. Naming a widget, a modifier
  or a layout primitive smuggles one stack into a document meant for several.
- **Describe what happens, not who decides.** "The card chooses how to show
  the explanation" is an implementation note wearing a contract's clothes.
- **Rules go under the attribute they govern**, except those about arrangement
  and space, which belong to the layout as a whole.
- **Open questions from step 1 stay open**, marked so, until something answers
  them. A question quietly resolved is a decision nobody reviewed.
- **Write only what you have measured or decided.** A line you have not checked
  reads the same as one you have, and a contract that promises what nobody
  verified is worse than one that stays silent. Mark an unverified claim as
  unverified, or leave it out.
- **One fact per line, and a note gives the reason, not the argument.** A
  section with a single line is honest when that is all you know. Restating a
  fact from another section is duplication, not emphasis.

**Done when:** a blueprint exists per promoted candidate, every silent item
from step 1 appears in one of them or is explicitly dropped, and no line names
a framework.
