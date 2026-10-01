---
name: skill-creation-methodology
description: >-
  An executable methodology for creating new skills — distilling how the
  top practitioners of ANY domain work into a SKILL.md that a
  lower-capability model can follow literally and still produce
  expert-level output. Governs how to identify the expert-vs-amateur gap
  in a field, extract the procedures, checks, orderings, and tripwires
  that experts never skip, structure them into a skill (frontmatter
  description, body, bundled references), write descriptions that trigger
  reliably, test the skill against realistic prompts, and keep the skill
  set consistent (AGENTS.md sync, no overlaps). Load this skill whenever
  the user wants to create, improve, review, or merge a skill —
  "make a skill for X", "turn this workflow into a skill", "スキル化して",
  "手順書にして", "このスキルを直して" — or whenever you notice a
  recurring task class that no existing skill covers.
---

# Skill Creation Methodology

A skill is a transfer of *procedure*, not persona. The end state is always
the same: a smaller, faster model opens the SKILL.md, follows it
literally, and produces work at the level of a top practitioner in that
domain. If the skill only works when the reader already has good
judgment, it has failed — the judgment is exactly what the skill must
supply.

This is the root discipline behind every skill in this repository,
including `claude-fable` itself. It works for any field — engineering,
research, writing, teaching, design, analysis — because in every field
the gap between the top 0.1% and a competent amateur has the same
structure.

## 1. The core move: find the expert–amateur gap

Do this before writing a single line. For the target domain, answer five
questions — this IS the skill's content; everything else is packaging:

1. **What do experts do that amateurs skip?** The unglamorous steps:
   reproducing a bug before fixing it, analyzing the audience before
   writing, drawing the figure skeleton before adding emphasis. Amateurs
   skip these because output *looks* achievable without them.
2. **In what order do experts work?** Ordering is often the entire
   secret: de-risk first, structure before emphasis, hypothesis before
   experiment. Capture the order and the *reason* for it.
3. **What checks do experts run before trusting a result?** Every domain
   has its verification ritual. These become the skill's self-check.
4. **What are the domain's tripwires?** The situations where amateurs
   keep going and experts stop: two failed fixes, a result that confirms
   the hypothesis too neatly, a p-value hunted after the fact. Tripwires
   are the highest-value content per line, because they fire exactly when
   a weaker model is about to go wrong.
5. **What does the expert refuse to do?** The don'ts that define the
   craft's taste — no fourth color on a slide, no fix without a failing
   test, no claim without a source.

Sources for these answers, in order of reliability: a real workflow
visible in the current conversation (the user just did the thing — mine
it); the user's own expertise (interview them: "what do beginners get
wrong in your field?"); primary sources and authoritative texts of the
domain; your own knowledge, verified where possible. When the domain is
outside your confident knowledge, research before distilling — a skill
that encodes amateur habits confidently is worse than no skill.

## 2. Interview before drafting

Ask the user (one focused round, not a questionnaire):

1. What should the skill enable, and what does a great output look like?
2. When should it trigger — what phrases, situations, file types?
3. Are there examples of expert-level output to imitate, or bad output
   to avoid? Concrete artifacts beat descriptions.
4. What will the skill compose with? (Existing skills, file-format
   skills, this repository's `claude-fable` frame.)

If the conversation already contains the answers — the user just walked
through the workflow, or handed you a design document — extract them
first and confirm, instead of asking what you already know.

## 3. Anatomy and repository conventions

```
skills/<name>/
├── SKILL.md            (required; uppercase filename)
│   ├── frontmatter     name + description
│   └── body            the methodology
└── references/         full specs, token tables, long documents
    scripts/            executable helpers for deterministic steps
    assets/             templates, images used in output
```

- Folder name must equal frontmatter `name`. Never duplicate a name.
- Progressive disclosure: description (~100 words, always in context) →
  body (<500 lines, loaded on trigger) → references (unlimited, loaded
  on demand). Push bulky exactness (token tables, schemas, long
  examples) into `references/` and point to it from the body, saying
  *when* to read it.
- If test runs show the model rebuilding the same helper script every
  time, write it once into `scripts/` and reference it.
- After creating or deleting a skill in this repository, update
  AGENTS.md in the same change: the Section 1 routing table, and a
  Section 2 disambiguation line if the new skill borders an existing
  one. A table that disagrees with the folders is worse than no table.

## 4. Write the description for triggering

The frontmatter description is the only part always in context — it
alone decides whether the skill fires. Rules:

1. Write "in which situations to open this," not just what it does.
2. Include concrete trigger vocabulary users actually type, including
   Japanese phrases if the user works in Japanese ("バグ", "レビューして",
   "スキル化して").
3. Be pushy. Models under-trigger skills; end with "even if the user
   never says X" style coverage for adjacent phrasings.
4. Draw the boundary: name what the skill does NOT cover when a sibling
   skill exists, so the two don't collide.

## 5. Write the body

- **Imperative voice, explained.** "Do X because Y." Today's models have
  good theory of mind; a rule with its reason generalizes to cases the
  rule's author never saw. A wall of ALWAYS/NEVER in caps is a yellow
  flag — reframe with the why, and save hard absolutes for the few
  rules that are genuinely non-negotiable.
- **Procedure over principle.** "Be rigorous" transfers nothing.
  "Lay out all nodes in white first; fill only the load-bearing ones
  blue; add red last" transfers everything. Every principle you're
  tempted to write should be converted into the steps an expert would
  actually take.
- **Generalize from examples, don't enshrine them.** You will develop
  the skill against 2–3 test cases; the skill will be used thousands of
  times on cases you never saw. When a fix works for a test case, ask
  what class of situation it represents and encode the class.
- **Include the expert's numbers.** Vague: "keep text large." Expert:
  "20pt floor; only sources and page numbers go smaller." Real
  thresholds are what let a weaker model act without judgment.
- **End with a self-check.** Every skill in this family closes with a
  short list the model runs before claiming completion — the Section 1
  question-3 checks, phrased as yes/no items where any "no" sends the
  model back to a named section.
- **Output formats:** when the deliverable has a fixed shape, show the
  exact template rather than describing it.

## 6. Quality gates (run on your draft)

1. **Distillation test.** Would a competent amateur following this
   literally outperform an unaided expert-imitation attempt? If a rule
   wouldn't change any decision, cut it — every line must pay rent.
2. **Literalness test.** Read the draft as a weaker model would: is
   there any step that secretly requires judgment the skill never
   supplies ("choose a good baseline" — good by what criterion?)? Fill
   those gaps or the skill will fail exactly when it matters.
3. **Composition test.** Does it work inside `claude-fable`'s frame
   without repeating it? A domain skill should not re-teach
   verification discipline or intent fidelity — it should assume the
   doctrine and add the domain. Overlap with sibling skills goes into
   an explicit boundary line, not silent duplication.
4. **Trigger test.** Read only the description: for five realistic user
   phrasings (include casual and Japanese ones), would it fire? For
   three near-miss requests that belong to a sibling skill, would it
   correctly stay silent?

## 7. Test, then revise

1. Write 2–3 realistic test prompts — the messy way a real user types,
   with file names and context, not clean textbook phrasing. Confirm
   them with the user.
2. Execute each prompt following the draft skill literally (or spawn a
   subagent with the skill, when available). Where you had to deviate
   from the skill to get a good result, the skill is missing that
   content — that deviation is the revision.
3. Give the outputs a hostile pass with `review-methodology`, then show
   the user and collect specific complaints.
4. Revise by generalizing from complaints (Section 5), not by patching
   each one with a narrow rule. Two rounds of this loop is normal; a
   skill that survives untouched was probably tested too gently.

## 8. Self-check before delivering a skill

1. Does the body encode the expert–amateur gap (steps, order, checks,
   tripwires, refusals) — or just describe the domain?
2. Could a weaker model follow every step literally, with thresholds
   instead of judgment calls?
3. Does the description say when to open it, with real trigger words,
   and a boundary against sibling skills?
4. Folder name = frontmatter name; no duplicate names; bulky exactness
   in references/; AGENTS.md table and disambiguation updated?
5. Has the skill been run against at least two realistic prompts, and
   did revisions come from generalizing the failures?
6. Does it compose with `claude-fable` without repeating it?

Any "no" sends you back to the numbered section that owns it.
