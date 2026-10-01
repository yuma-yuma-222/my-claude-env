---
name: professional-writing-workflow
description: An executable workflow for producing professional writing that is clear, accurate, persuasive, and maintainable. Covers the full process — audience analysis, information hierarchy, outlining, drafting, revision, clarity improvement, ambiguity elimination, consistency checking, style adaptation, factual verification, and final editing — plus genre-specific methodologies for technical writing, documentation, proposals, blog articles, educational content, and executive summaries. Load this skill for any substantive writing task: reports, docs, READMEs, RFCs, pitches, posts, tutorials, summaries, or whenever a draft needs professional-grade revision rather than a quick reply.
---

# Professional Writing Workflow

## Purpose

Professional writing fails in predictable ways: written for the writer instead of the reader, organized by the order of the author's thinking instead of the reader's need, revised for polish instead of structure, and shipped with unverified facts wearing confident prose. This procedure inverts each failure: **the reader's situation drives every decision**; structure is fixed before sentences are polished; and every claim is checked against its source before delivery.

The governing test for every choice in this document: *what does the intended reader need, in what order, and what will they do with it?* Writing quality is measured at the reader, not at the page.

Standing rules:

1. **Never draft before the outline carries the argument.** If the outline doesn't work, no sentence-level skill will save it.
2. **Never revise structure and sentences in the same pass.** Structure first; polishing sentences that will be deleted is waste, and pretty sentences protect bad structure from deletion.
3. **Never ship a claim you haven't verified or explicitly hedged.** Confident prose is not evidence.

---

## Part 1 — Audience analysis (before anything else)

Answer these in writing before outlining. If the answers aren't inferable from the request, ask one consolidated question or state the assumptions in the deliverable.

1. **Who reads this, and in what situation?** Role, expertise level, and reading context (skimming an inbox, following steps at a terminal, evaluating a purchase, studying). The situation dictates format more than the topic does.
2. **What do they already know?** This sets the vocabulary floor and the explanation ceiling. Writing below the reader's knowledge insults; above it, excludes. For mixed audiences, write for the primary reader and serve others with structure (linked background, appendices, expandable detail) — not by averaging, which serves no one.
3. **What should they do or decide after reading?** Every professional document has a desired outcome: approve, configure, understand, buy, change behavior. Name it. Content that doesn't serve the outcome is a cut candidate.
4. **What's their disposition?** Friendly, skeptical, hostile, indifferent? A proposal to a skeptic front-loads objections; a tutorial for the anxious front-loads reassurance and early wins.
5. **What will they search for later?** Maintainable writing is findable writing: choose headings and terms the reader would use as search queries, not clever ones.

**Exit condition:** reader, prior knowledge, desired outcome, and reading situation written down. These four lines govern every later decision; when stuck on any choice below, return to them.

## Part 2 — Information hierarchy

1. **Order by reader need, never by chronology of your work or discovery.** "What I did first" is the writer's order; "what you need first" is the reader's. Default professional order: the point → the support → the detail (inverted pyramid). The reader who stops after one paragraph should leave with the most important thing.
2. **State conclusions before justifications** in business and technical prose (BLUF: bottom line up front). Suspense is for fiction; in professional writing, the reader uses the conclusion to decide how much justification to read.
3. **One idea per unit, at every scale.** One point per document (the "so what" you could state in a sentence — write this sentence down; it's the arbiter of relevance). One topic per section. One idea per paragraph, stated in its first sentence — a reader skimming only first sentences should get the full argument.
4. **Layer for multiple depths of reading.** Professional documents are read three ways: skim (headings + first sentences), normal (full body), and deep (appendices, footnotes, links). Design all three paths deliberately: informative headings that assert, not label ("Latency doubled after the cache change", not "Performance"); details pushed down into layers rather than deleted or inlined.
5. **Front-load within every unit:** key word early in the sentence, key sentence early in the paragraph, key section early in the document. Endings get the second-best position (they're remembered); middles get what merely must exist.

## Part 3 — Outlining

1. **Outline in full sentences, not topics.** "Migration risks" is a label that hides whether you have anything to say; "The migration's main risk is the 45-minute write freeze" is a claim that can be evaluated, ordered, and supported. A topic outline defers all the hard decisions to the draft, where they're expensive.
2. **Attach evidence to each claim in the outline** — the data point, example, or source that will support it. A claim with no evidence attached is flagged now (research it or cut it), not discovered missing mid-draft.
3. **Walk the outline as the reader:** does each claim follow from what precedes it? Is anything needed before it's available? Would the target reader's top objection be handled where it occurs to them? Fix sequence problems here — reordering an outline costs seconds; reordering a draft costs the draft.
4. **Check the outline against Part 1:** does the sequence serve the desired outcome? Does the skim path (the claims alone) work? Is the one-sentence "so what" actually delivered?
5. For documents over ~2 pages, **get the outline approved** (by the user, or stated in the deliverable) before drafting. Outline changes are cheap; draft rewrites are not.

## Part 4 — Drafting

1. **Draft fast and forward against the outline; do not edit while drafting.** Drafting and editing are different modes; alternating them produces slow, over-worked openings and starved endings. Mark rough spots with a token (`[TK]`, `[verify]`, `[weak]`) and keep moving. Note: facts you're unsure of get `[verify]` *at the moment of writing* — this creates the checklist Part 9 runs; unsure facts written confidently are how errors survive to publication.
2. **Start with the easiest section, not the introduction.** Introductions are written last, when you know what you're introducing. Drafting the intro first produces throat-clearing that must be deleted anyway.
3. **Write to the paragraph's first-sentence claim** (from the outline): everything in the paragraph supports that sentence or moves out.
4. **When drafting stalls, the outline is usually wrong there.** Don't push prose through a broken structure — return to the outline, fix the claim or its position, resume.

## Part 5 — Revision (structure pass)

Revision proceeds in ordered passes, largest concerns first. Pass 1 is structural and happens *before* any sentence polishing (standing rule 2).

1. **Re-read as the target reader, in their situation** — ideally after a gap, or by changing the format (different font/medium) to break familiarity. Familiarity is the enemy: you read what you meant, not what's written.
2. **Run the skim test:** read only headings and first sentences. If the argument doesn't carry, fix topology before touching prose.
3. **Cut to serve the outcome.** For each section: what does the reader lose if this goes? "Nothing they need" → cut or demote to a layer. The most common professional-writing defect is not bad sentences but unearned length — respect for the reader is measured in their minutes.
4. **Check openings and closings.** The opening must establish, within a few sentences, what this is, who it's for, and why to keep reading. The closing must land the desired action or takeaway — never trail off into caveats.
5. **Verify each objection is handled where it arises.** Skeptical readers generate objections at specific points; an answer three sections later arrives too late.

## Part 6 — Clarity improvement (sentence pass)

Apply after structure is stable. Mechanical, per-sentence operations:

1. **Prefer subject–verb–object with concrete actors.** "The team rejected the proposal" beats "the proposal was subjected to a rejection process." Passive voice is permitted precisely where the actor is unknown or irrelevant ("the file is encrypted at rest") — a deliberate choice, not a default.
2. **Convert nominalizations back to verbs:** "make a decision" → "decide"; "perform an analysis of" → "analyze"; "-tion/-ment/-ance" nouns are the tell.
3. **Cut throat-clearing and intensifiers:** "It is important to note that", "basically", "very", "in order to" → "to". Each deleted filler word raises the density of what remains.
4. **One thought per sentence; average short, vary rhythm.** Long sentences are permitted when their structure is parallel and their content is one thought; sentences juggling three thoughts split.
5. **Replace abstraction with specifics wherever a specific exists:** "significantly improved performance" → "cut p95 latency from 800ms to 210ms". Specificity is simultaneously clearer, more credible, and more persuasive — it's the highest-leverage edit in professional prose.
6. **Define terms at first use or link them; expand acronyms once.** Then use the defined term *consistently* (see Part 8 — synonym variety is a literary virtue and a technical vice).

## Part 7 — Eliminating ambiguity

Hunt these specific constructions; each is a defect with a mechanical fix:

1. **Unanchored pronouns:** "it", "this", "which" with two possible referents. Fix: repeat the noun or restructure. Test: can a hostile reader attach the pronoun to the wrong antecedent?
2. **Dangling comparisons and quantities:** "faster", "cheaper", "most users" — than what, by how much, measured how? Fix: supply the baseline and the number, or delete the claim.
3. **Ambiguous scope:** "all users with admin rights or a token" — does "all" bind both? Fix: parenthesize in words ("users who have either admin rights or a token") or restructure as a list.
4. **Modal and requirement words used loosely:** "should", "may", "can", "must" each carry different obligations. In technical and contractual writing, pick a convention (e.g., must = required, should = recommended, may = optional), state it if the document is normative, and audit every instance against it.
5. **Time and version deixis:** "currently", "recently", "the new API" rot as the document ages. Fix: absolute dates and version numbers ("as of v2.3", "in March 2026"). This is the single biggest maintainability edit — "current" is false the day after it's true.
6. **Negation stacking:** "not uncommon", "cannot exclude", "no reason not to". Fix: restate positively.
7. **Instructions with hidden state:** "run the command" (which directory? which environment? as which user?). Fix: every instruction names its preconditions, or the sequence establishes them explicitly.

## Part 8 — Consistency checking

Inconsistency reads as carelessness and, in documentation, causes real errors. Check mechanically — these are not judgment calls:

1. **Terminology:** one name per concept for the whole document. If it's "repository" in section 1, it isn't "repo" in section 4 and "codebase" in section 6. Build a small term list while drafting; sweep against it (search works; eyes miss).
2. **Formatting conventions:** heading capitalization style, list punctuation, code formatting for identifiers, number style (spelled vs. numeral), date format, units — each decided once, applied everywhere.
3. **Structural parallelism:** items in a list share grammatical form; sibling sections share internal structure (if one option gets "cost / risk / timeline", all options do — readers use the first instance as a template for reading the rest).
4. **Claims vs. claims:** numbers that appear twice agree; the summary promises only what the body delivers; the conclusion contradicts nothing above it.
5. **Voice and register:** person (we/you/one), formality, and tense stay stable unless a section boundary justifies the shift.
6. Where a style guide exists (house style, docs standards), it wins over personal preference — note deviations only when deliberate and flag them.

## Part 9 — Factual verification

Run before final editing, on the draft's actual text:

1. **Sweep every `[verify]` token** left during drafting; none may survive to delivery.
2. **Check every number, name, date, version, URL, command, and code sample against its source** — the source itself, not memory of it. Misremembered specifics are the most common and most damaging professional-writing error, because they're precise-looking and wrong.
3. **Execute what can be executed.** Commands, code snippets, and step sequences in technical writing are run, not proofread — a doc's untested instructions are bugs shipped to every reader. Record what was executed and what couldn't be (and say so in the doc if it matters).
4. **Classify every remaining claim:** sourced (citation attachable), derived (from stated facts by visible reasoning), or asserted (opinion/judgment — must read as such: "we recommend", not "it is known"). No asserted claim may wear sourced clothing.
5. **Check quotes and paraphrases against originals** for scope distortion — dropped qualifiers turn "may reduce risk in some configurations" into "reduces risk".
6. In persuasive genres, verify the *strongest* claims hardest: the headline number, the comparison to alternatives, the promise of outcome. These are the ones readers will check and opponents will attack.

## Part 10 — Style adaptation

Style is a controlled variable set by audience and genre, not a fixed voice:

1. **Set the register from Part 1:** expert-to-expert (dense, jargon-legitimate, minimal scaffolding) ↔ expert-to-novice (defined terms, worked examples, more signposting) ↔ persuasive (benefit-led, objection-aware) ↔ reference (terse, uniform, optimized for lookup not linear reading).
2. **Adapt these variables independently:** sentence length, technicality of vocabulary, person and directness ("you must" vs. "it is required"), hedging density, and warmth. A doc can be technical *and* warm (tutorials), or plain-language *and* cold (legal notices).
3. **Match existing corpus when the document joins one** — a new page in an established docs site, a section in someone's report. Sample 2–3 neighboring documents; consistency with the corpus outranks your defaults (same principle as code conventions).
4. **When in doubt, choose plain.** Between two registers, the plainer one is almost always right; nobody has ever complained that a professional document was too easy to understand.

## Part 11 — Final editing checklist

Run on the final artifact, after the last content change (any edit after this checklist re-triggers the relevant items):

- [ ] Read start-to-finish in the reader's situation once more, without touching anything until the read completes
- [ ] The one-sentence "so what" (Part 2.3) is actually stated in the document, early
- [ ] Skim path works: headings + first sentences alone carry the argument
- [ ] All `[TK]`/`[verify]`/`[weak]` tokens resolved — search for them, don't trust recall
- [ ] Ambiguity sweep (Part 7) run on final text: pronouns, comparisons, scope, modals, deixis, negations
- [ ] Consistency sweep (Part 8) run: terms, formatting, parallelism, number agreement
- [ ] Verification complete (Part 9): every number/name/command checked or the claim hedged
- [ ] Openings and closings earn their positions; no trailing caveat-fade
- [ ] Length audited against reader minutes: nothing survives that the reader doesn't need
- [ ] Titles, headings, and filenames are what the reader would search for
- [ ] Rendered output inspected in its delivery format (markdown rendered, doc opened, email previewed) — formatting errors live in the gap between source and render
- [ ] Delivery note states anything unverified, assumed, or deliberately out of scope

---

## Genre methodologies

Each genre inherits the full workflow above; listed here are the deltas — what changes per genre.

### Technical writing (RFCs, design docs, analyses)

- Reader outcome: *a correct decision or correct implementation.* Optimize for verifiability: claims carry evidence inline, alternatives considered are documented with rejection reasons (the reader's first question is "did they think of X?").
- Structure: context → proposal/finding → alternatives → consequences/risks → appendix detail. State the recommendation on page one (BLUF), even when the analysis is long.
- Precision beats elegance on every conflict. Repetition of exact terms is correct; ambiguity to avoid repetition is a defect.
- Include the "how to evaluate this" material: assumptions, test methodology, what would change the conclusion.

### Documentation (READMEs, guides, references, runbooks)

- Reader situation: *mid-task, impatient, non-linear.* They arrive by search, land anywhere, and read nothing before the section they landed on — every section must therefore stand alone or link its prerequisites explicitly.
- Separate the four doc types and don't blend them in one page: tutorial (learning-oriented, one guaranteed-success path), how-to (task-oriented, assumes competence), reference (lookup-oriented, complete and uniform), explanation (understanding-oriented, background and why).
- Every instruction sequence: states preconditions, shows expected output at checkpoints ("you should now see…"), and covers the most likely failure at each step. Untested instructions are bugs (Part 9.3).
- Maintainability is a first-class requirement: absolute versions/dates, single-sourced facts (one place to update), and structure that accepts additions without reorganization. Write for the person updating it in a year — often not you.

### Proposals (pitches, RFPs, internal cases)

- Reader outcome: *a yes from a specific decider.* Analyze the actual decision-maker, their criteria, and their alternatives (including "do nothing" — the incumbent competitor in every proposal).
- Structure: their problem in their terms → proposed outcome and its value → how (only as much as credibility requires) → evidence you can deliver → risks named honestly with mitigations → the specific ask. The ask is concrete and singular: what decision, by when.
- Preempt the top three objections explicitly; a skeptic's objection answered before they voice it becomes trust.
- Every benefit claim quantified or exampled (Part 6.5); every quantity verified hardest (Part 9.6). One inflated number discredits the honest ones.

### Blog articles (public technical/professional posts)

- Reader situation: *voluntary, one scroll from leaving.* The title and first two sentences carry the entire retention burden: lead with the payoff or the genuinely interesting tension, never with background.
- One idea per post. The test: the reader can retell the point to a colleague in one sentence.
- Voice is warmer and first-person is fine, but the standards don't relax: claims still verified, specifics still beat abstractions — a post's credibility is its details.
- End with something usable: the takeaway, the code, the checklist. Delete concluding paragraphs that merely restate.

### Educational content (tutorials, courses, explainers)

- Reader outcome: *durable capability, not exposure.* Sequence concepts by prerequisite (each unit uses only what's been established), one new idea per unit, concrete example before general rule, always.
- Build in active checkpoints: exercises, predict-the-output, "try before reading on" — comprehension without production doesn't persist. Where a full tutoring loop is warranted, defer to a dedicated tutoring methodology; within written content, the checkpoint pattern is the minimum.
- Anticipate the canonical misconceptions of the topic and address them where they arise, by showing where the wrong model fails — not just by stating the right one.
- Show errors and their repair, not only clean paths: learners meet the errors; content that pretends otherwise abandons them at first failure.

### Executive summaries

- Reader situation: *90 seconds, deciding whether and what to delegate.* The summary is a complete document, not a teaser — the executive may read nothing else, so it must contain: the situation in one line, the finding/recommendation, the two or three numbers that matter, the risk that matters, and the decision requested.
- Order: recommendation first, always. Support in descending importance. No suspense, no methodology, no hedging cascades — one honest confidence statement replaces five scattered qualifiers.
- Length discipline: half a page as the default ceiling; every sentence earns placement by answering "does the decider need this to decide?"
- Numbers in a summary are checked twice (Part 9): a wrong number here propagates into decisions immediately.
- Write it last, from the finished document — it summarizes what is, not what was planned.

---

## Worked micro-example (workflow compressed)

Task: "Write up our database migration for the engineering org."

- **Part 1:** Readers: engineers who'll operate the new system (primary), leads deciding rollout timing (secondary). Outcome: engineers can run the migration; leads can pick a date. Situation: skimmed in Slack, referenced mid-task later. → Two-layer document: decision summary up top for leads, runnable runbook below for engineers.
- **Parts 2–3:** Sentence outline, claims first: "The migration requires a 45-minute write freeze" (evidence: staging timing run), "Rollback is possible until step 6, not after" (evidence: schema-change semantics — flagged `[verify]`). Skim path checked at outline stage.
- **Part 4:** Drafted runbook-first (easiest), intro last. Unsure of the freeze duration on production hardware → `[verify: staging≠prod disk]` at the moment of writing.
- **Parts 5–8:** Skim test catches that rollback-limit appears *after* the step it limits — reordered (structure pass) before any sentence polish. Ambiguity sweep catches "the new database" (deixis → "PostgreSQL 16 cluster `pg-main-2`") and a dangling "must" convention → convention stated. Consistency sweep: "write freeze" vs "read-only window" unified.
- **Part 9:** Every command executed in staging; the `[verify]` on prod timing resolved by scaling calculation — presented as a derived estimate with its method, not as a measured fact. Expected-output lines added at checkpoints.
- **Part 11:** Rendered markdown inspected (a broken table found and fixed); delivery note: "freeze duration on prod is estimated, not measured — method in appendix; measure during the dry run."

The signature of the workflow: the two most important edits (reordering the rollback warning; downgrading an estimate from fact to derived claim) were caught by process — the skim test and the claim classification — not by prose sensibility.
