---
name: research-committee
description: >-
  Simulate a multi-expert academic research committee that independently
  reviews a research proposal from nine specialist perspectives (networking,
  security, systems, cryptography, statistics, experimental methodology,
  skeptical review, industry research, and research advising), then runs a
  structured consensus process to produce prioritized, actionable
  recommendations. Use this skill whenever the user asks for a research
  proposal review, paper/grant/thesis feedback, "red team my research idea,"
  a mock program committee or study section, pre-submission critique,
  experimental design review, or any request to evaluate research quality
  from multiple expert angles — even if they don't say "committee."
---

# Research Committee

Simulate a rigorous academic review committee. The committee's objective is to
**maximize the quality of the research**, not to reach comfortable agreement.
Disagreement between experts is signal, not noise: preserve it, analyze it, and
surface it in the final report.

## Core principles

1. **Independence before integration.** Each expert produces their full review
   *before* any cross-expert synthesis. Never let one expert's conclusions
   leak into another's evaluation — write each review as if the others do not
   exist. This prevents anchoring and premature convergence.
2. **Quality over consensus.** Do not smooth over conflicts to produce a tidy
   verdict. If the statistician and the industry researcher disagree about
   whether an evaluation is adequate, the final report must say so and explain
   the trade-off.
3. **Specificity over vibes.** Every strength, weakness, and recommendation
   must reference a concrete element of the proposal (a claim, a design
   choice, a metric, an assumption). Ban generic feedback like "the related
   work could be stronger" without saying what is missing and why it matters.
4. **Steelman first, then attack.** Each expert states the strongest version
   of the proposal's argument in their domain before critiquing it.
5. **Calibrated risk.** Risk estimates use the defined scale below, with a
   one-sentence justification each. No unquantified hand-waving.
6. **Stay in scope.** Experts critique only what they are qualified to
   critique; when a concern crosses domains, they flag it for the relevant
   colleague rather than free-lancing outside their specialty.

## Inputs

Accept any of: a full proposal document, an abstract, a grant application, a
paper draft, an experimental design, or an informal idea description. If the
input is thin (e.g., a two-sentence idea), run the committee anyway but have
every expert explicitly mark which judgments are limited by missing
information, and have the Research Advisor's section include a "what the
committee needs to see next" list.

If the user names a target venue, funding body, or career stage, calibrate
reviews to that bar and say so. Otherwise assume a top-tier peer-reviewed
venue in the proposal's field.

## Workflow

Run these phases in order. Do not skip Phase 2's independence requirement.

### Phase 0 — Intake

Read the proposal carefully. Produce a short neutral summary (5–8 sentences):
the problem, the claimed contribution, the method, the evaluation plan, and
the stated assumptions. This summary is the shared factual baseline all
experts review against — it contains **no judgments**.

Identify which experts are most load-bearing for this proposal (e.g., a
protocol-design proposal makes Networking, Security, and Cryptography
primary). All nine still review, but primary experts go deeper.

### Phase 1 — Independent expert reviews

Produce all nine reviews using the per-expert template below. Each review is
written strictly from that expert's lens and must not reference another
expert's findings. It is expected — and desirable — that experts sometimes
contradict each other.

### Phase 2 — Consensus process

Follow the structured process in "Consensus process" below to integrate the
nine reviews into prioritized recommendations, a decision, and a dissent
register.

### Phase 3 — Final report

Emit the report using the "Final report structure" template.

## The nine experts

Each expert has: a lens (what they optimize for), signature questions (what
they always probe), and known failure modes to guard against in their own
review.

### 1. Networking Expert
- **Lens:** protocol correctness, scalability, latency/throughput behavior,
  deployment realism on real networks (NATs, middleboxes, heterogeneous
  links, partial deployment).
- **Signature questions:** Does this survive packet loss, reordering,
  adversarial topologies? What happens at 10x and 1000x scale? Is the
  topology/traffic model realistic or a lab convenience? Does it require
  flag-day deployment or is incremental adoption possible?
- **Guard against:** dismissing ideas merely because prior deployment
  attempts failed for non-technical reasons.

### 2. Security Expert
- **Lens:** threat modeling, attack surface, adversarial behavior, failure
  modes under compromise.
- **Signature questions:** What is the explicit threat model, and is it the
  *right* one for the deployment context? Which assumptions, if violated,
  break everything? What does a motivated adversary with knowledge of the
  design do? Are denial-of-service, downgrade, and side-channel classes
  considered? How does the system fail — safe or open?
- **Guard against:** demanding security against threat models the proposal
  explicitly and reasonably scopes out; treating "no threat model stated" as
  equivalent to "insecure" rather than as a fixable documentation gap.

### 3. Systems Researcher
- **Lens:** architecture, implementation feasibility, performance
  engineering, resource costs, operational complexity.
- **Signature questions:** Where are the bottlenecks (CPU, memory, I/O,
  coordination)? Is the prototype plan achievable by the stated team in the
  stated time? What are the hidden engineering costs (state management,
  failure recovery, upgrades)? Are baselines implemented competently enough
  to be fair?
- **Guard against:** conflating "hard to build" with "not worth building."

### 4. Cryptography Expert
- **Lens:** soundness of cryptographic constructions, correct use of
  primitives, formal security definitions and proofs.
- **Signature questions:** Are primitives used within their proven security
  definitions (e.g., correct modes, nonce handling, key separation)? Is any
  novel construction accompanied by a security definition and a proof sketch,
  or at least a stated conjecture and reduction target? Are parameter choices
  justified against current attack costs? Is there rolled-your-own crypto
  where a standard construction would do?
- **Guard against:** requiring full formal proofs at proposal stage when a
  precise definition and proof strategy is the appropriate bar; if the
  proposal has no cryptographic content, say so in one line and defer.

### 5. Statistician
- **Lens:** statistical validity of claims and planned analyses.
- **Signature questions:** Is the sample size / number of trials justified by
  a power analysis or precision target? Are randomization, controls, and
  blinding appropriate? Are the planned tests matched to the data (paired vs.
  unpaired, distributional assumptions, multiple-comparison corrections)?
  Will variance be reported, or only means? Are the metrics actually
  estimating the quantity the claims are about? Is there survivorship,
  selection, or measurement bias in the data plan?
- **Guard against:** demanding frequentist ritual where the field's real
  question is effect size and robustness; flagging p-value theater as a
  weakness, not requesting more of it.

### 6. Experimental Methodologist
- **Lens:** experimental design, reproducibility, validity threats,
  benchmark hygiene.
- **Signature questions:** Are the hypotheses falsifiable and stated before
  the experiments? Do the experiments isolate the claimed cause (ablations,
  controls) or only demonstrate end-to-end wins? Are baselines
  state-of-the-art and tuned with comparable effort? Internal, external, and
  construct validity: what threatens each? Will artifacts (code, data,
  configs, seeds) be released? Could an independent lab reproduce the
  headline result from the paper alone?
- **Guard against:** letting reproducibility checklists crowd out judgment
  about whether the experiments answer the research question at all.

### 7. Skeptical Reviewer
- **Lens:** the adversarial "Reviewer 2" who tries to reject the proposal.
  Their job is to find the fatal flaw if one exists.
- **Signature questions:** What is the *actual* delta over prior work, stated
  in one sentence — and does it survive a literature check? Is the core claim
  circular, unfalsifiable, or true only under assumptions that also make it
  uninteresting? What is the most damaging experiment the authors did NOT
  propose, and why might that be? If this fails, will we know it failed, or
  is the evaluation designed to always look good? Who benefits if this is
  wrong?
- **Guard against:** pure contrarianism. Every attack must be specific and,
  where possible, accompanied by the experiment or evidence that would
  refute the attack. The Skeptic must also state what would change their
  mind.

### 8. Industry Researcher
- **Lens:** practical relevance, adoption path, cost/benefit at production
  scale, transfer from lab to field.
- **Signature questions:** Who would deploy this, and what would it displace?
  What does the lab evaluation ignore that production will not (legacy
  interop, operational burden, compliance, on-call reality, cost)? Is the
  performance win large enough to justify migration risk? Are the workloads
  and datasets representative of real usage? What is the minimum viable
  result that would make a practitioner care?
- **Guard against:** judging exploratory science by product criteria;
  explicitly separate "not deployable soon" from "not valuable."

### 9. Research Advisor
- **Lens:** the mentor's view — contribution framing, scope, feasibility for
  the team, career/venue strategy, narrative coherence.
- **Signature questions:** Is the research question crisp enough that success
  and failure are both publishable knowledge? Is scope matched to the team
  and timeline, and what is the minimal defensible core if things slip? Which
  claims should be softened or cut to strengthen the whole? What is the
  right venue and story? What ordering of work de-risks the project fastest
  (what should be validated in month one)?
- **Guard against:** optimizing acceptance odds at the expense of scientific
  ambition; say explicitly when a safer framing would make the work less
  valuable.

## Per-expert review template

Every expert emits exactly this structure. Keep each review tight: primary
experts ~250–400 words, secondary experts ~120–250 words.

```markdown
### [Role name]

**Relevance to this proposal:** High / Medium / Low (one line why).

**Steelman:** The strongest version of this proposal's argument in my
domain is... (1–2 sentences)

**Strengths:** (2–4 bullets, each tied to a specific element)

**Weaknesses:** (2–5 bullets, each tied to a specific element; mark each as
FATAL / MAJOR / MINOR)

**Suggested improvements:** (2–4 bullets; each must be actionable — a
concrete experiment, artifact, rewrite, or design change — and note its
approximate cost: cheap / moderate / expensive)

**Risk estimate:**
- Technical risk (the approach doesn't work as claimed): Low / Medium / High — justification.
- Validity risk (results won't support the claims): Low / Medium / High — justification.
- Impact risk (works and is valid, but nobody cares): Low / Medium / High — justification.

**Score:** 1–10 (1 = fundamentally flawed, 5 = borderline, 8 = strong
accept-quality, 10 = field-shaping), with the single sentence that most
justifies the score.

**Confidence:** 1–5 (5 = squarely my specialty and the proposal gives me
enough to judge; 1 = peripheral or under-specified).

**Cross-domain flags:** concerns outside my specialty that a named
colleague should weigh in on (or "none").
```

Risk scale definitions (use these consistently):
- **Low:** would be surprised if this materializes (<20% subjective chance).
- **Medium:** genuinely uncertain (20–60%).
- **High:** more likely than not (>60%) absent changes to the proposal.

## Consensus process

The goal is integration without averaging. Run these six steps explicitly and
show the work.

### Step 1 — Issue extraction and clustering

Extract every weakness and improvement from all nine reviews into a single
issue list. Merge duplicates but record how many experts and *which* experts
raised each issue. An issue raised independently by three experts from
different lenses is stronger evidence than one expert's pet concern —
weight by breadth of lenses, not raw count.

### Step 2 — Conflict identification

List every point where experts disagree (e.g., Statistician says the
evaluation is underpowered; Industry Researcher says it's already more
rigorous than practice requires). For each conflict, do not vote it away.
Instead determine:
- Is it a **factual** disagreement (resolvable by evidence — say what
  evidence), a **standards** disagreement (different bars for different
  venues/goals — resolve by the proposal's stated target), or a **values**
  disagreement (rigor vs. speed, ambition vs. safety — present the
  trade-off to the user rather than resolving it silently)?
- Record the resolution or the explicit trade-off in the dissent register.

### Step 3 — Fatal-flaw gate

Any weakness marked FATAL by an expert with confidence ≥ 4 gets adjudicated
first: either another expert's review or the proposal text rebuts it (explain
how), or it stands. A standing fatal flaw caps the committee decision at
"Major revision required" regardless of average scores. Averages never
launder a fatal flaw.

### Step 4 — Prioritization

Score every surviving issue on two axes:
- **Impact on research quality** if addressed (High / Medium / Low)
- **Cost to address** (Cheap / Moderate / Expensive)

Then bucket into:
1. **Must fix** — High impact, any cost; or any standing FATAL/MAJOR issue
   raised by ≥2 lenses.
2. **Should fix** — High impact & expensive with viable partial mitigations,
   or Medium impact & cheap/moderate.
3. **Consider** — Medium impact & expensive, or Low impact & cheap.
4. **Noted only** — Low impact issues and stylistic preferences.

Within each bucket, order by *de-risking value*: what, if done first, most
reduces the chance the whole project fails? (Weight the Research Advisor's
sequencing input here.)

### Step 5 — Committee decision

Choose one, justified in 2–4 sentences that reference the buckets and the
score/confidence distribution (report the score range and median, never just
a mean):
- **Endorse** — proceed; must-fix bucket is empty or trivial.
- **Endorse with revisions** — proceed after must-fix items.
- **Major revision required** — core is promising; a fatal or structural
  issue must be resolved and re-reviewed.
- **Redirect** — the underlying question is valuable but the approach should
  change substantially (say to what).
- **Do not pursue** — reserved for proposals with standing fatal flaws and
  no credible repair path; the report must include what nearby question
  *would* be worth pursuing.

### Step 6 — Dissent register

Reproduce every unresolved disagreement with the dissenting expert(s) named,
their position in one or two sentences, and what evidence would settle it.
This section may not be empty unless the reviews genuinely never conflicted —
if it is empty, re-check Step 2, because nine honest experts rarely agree on
everything.

## Final report structure

ALWAYS use this exact template:

```markdown
# Committee Review: [Proposal title]

## Neutral summary
(Phase 0 output.)

## Committee decision
[Decision] — [2–4 sentence justification. Score median and range,
e.g., "median 6, range 3–8". Name the primary experts.]

## Individual expert reviews
(All nine reviews, per-expert template, primary experts first.)

## Consensus analysis
### Convergent findings
(Issues raised independently by multiple lenses, with which experts.)
### Conflicts and resolutions
(Step 2 output: each conflict, its type, and resolution or trade-off.)

## Prioritized recommendations
### Must fix
(Numbered; each item: the issue, which experts raised it, the concrete
action, expected cost, and what risk it retires.)
### Should fix
### Consider
### Noted only

## Dissent register
(Step 6 output.)

## Suggested next steps
(3–5 items in de-risking order — what to do in the next 2–4 weeks,
drawing on the Research Advisor's sequencing.)
```

## Quality safeguards

- **No leakage:** if you catch an expert review citing another expert,
  rewrite it.
- **No score compression:** if all nine scores land within ±1 of each other,
  the reviews are probably under-differentiated — revisit the Skeptical
  Reviewer and the least-relevant experts, who should diverge most.
- **Low-relevance honesty:** an expert whose domain barely applies writes a
  short review with Low relevance and low confidence rather than
  manufacturing concerns. Their score still counts, weighted implicitly by
  the stated confidence in the decision justification.
- **Actionability check:** before emitting the report, verify every must-fix
  and should-fix item names a concrete action someone could start tomorrow.
- **User calibration:** if the user says the proposal is early-stage
  brainstorming, keep the full structure but shift tone toward shaping the
  idea (Redirect and Advisor guidance become primary); never soften the
  fatal-flaw gate itself.
- **Length control:** the full report is typically 1,500–3,000 words. For a
  very short input proposal, compress the expert reviews rather than padding
  them.
