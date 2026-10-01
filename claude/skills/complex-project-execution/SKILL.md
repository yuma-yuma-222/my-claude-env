---
name: complex-project-execution
description: An executable methodology for planning and executing large, complex projects that span many working sessions and carry significant uncertainty. Governs understanding objectives, identifying constraints, defining success criteria, task decomposition, dependency analysis, prioritization, milestone planning, risk assessment, contingency planning, execution tracking, adapting plans when assumptions break, and choosing the next best action. Load this skill for any multi-session undertaking — building a substantial system, a research program, a migration, a book or major document, a product launch, an investigation — and whenever work has outgrown a single to-do list or a plan has just collided with reality.
---

# Complex Project Execution

## Purpose

Large projects fail differently than large tasks. Tasks fail through bad execution; projects fail through *state loss and plan decay*: objectives drift unnoticed, finished work goes unrecorded and gets redone, dead assumptions keep steering, risks everyone sensed go unwritten and then materialize, and each session starts with expensive reconstruction of what was true. This procedure treats those as the primary enemies. Its central mechanism: **the project's entire state lives in written artifacts, not in anyone's memory** — an agent (or person) with no recollection of previous sessions must be able to resume correctly from the artifacts alone. Every rule below either builds that state, keeps it true, or uses it to choose the next action.

Standing rules:

1. **No work outside the plan; no plan that ignores the work.** Anything worth doing gets added to the plan first (a one-line addition suffices); anything the work discovers gets written back into the plan. The plan and reality are never allowed to diverge silently.
2. **Uncertainty is scheduled, not hoped away.** The unknowns get investigation tasks with dates, ordered ahead of the work that depends on them.
3. **Every session ends with a written handoff.** A session whose results exist only in context is a session partially lost.

---

## Part 1 — Understanding objectives

1. **Interrogate the objective until it names an outcome, an owner, and a reason.** "Build a data platform" is a project title; "analysts can self-serve queries on unified customer data, replacing the 2-week request cycle through the data team" is an objective — it says what changes in the world, for whom, and why it's worth the cost. Ask (or infer and state): *what becomes possible that isn't now? Who benefits? What happens if we don't do this?*
2. **Separate the objective from the current favorite solution.** Requests usually arrive solution-shaped ("migrate us to Kubernetes"). Record both the stated solution and the underlying objective ("deploys are slow and risky") — because when the solution hits trouble mid-project, the objective is what tells you whether to push through or pivot. A project that has forgotten its objective can only fail conventionally.
3. **Identify the stakeholders and the decider.** List who is affected, who must be consulted, and — singular where possible — who accepts the result. Ambiguity about the decider is a project risk from day one; log it as such (Part 8) if it can't be resolved.
4. **Write the objective statement into the project charter** (the head of the plan document, Part 10): 3–6 sentences — outcome, beneficiary, motivation, and what is explicitly *out of scope*. The out-of-scope list is half the value: scope creep enters through what was never written down as excluded.

## Part 2 — Identifying constraints

1. **Enumerate constraints by category, in writing:** deadline and immovable dates; budget/resources; technical givens (must integrate with X, must run on Y, can't touch Z during business hours); regulatory/policy; people (skills available, approval chains); and quality floors (uptime, accuracy, security baselines that cannot be traded).
2. **Classify each as hard or soft — and verify the hard ones.** "The deadline is March 1" — is that a contract, a preference, or someone's guess? Constraints inherit false hardness through repetition; a project planned around a soft constraint treated as hard pays for flexibility it actually had. Interrogate: *what actually happens if this constraint is violated?* The answer sorts them.
3. **Find the binding constraint.** Usually one constraint dominates the plan's shape (the date, the one expert's availability, the integration freeze window). Name it explicitly — prioritization (Part 6) and contingency design (Part 9) both key off it.
4. **Record constraints as assumptions when they're actually assumptions.** "The API team will deliver their endpoint by month two" is not a constraint; it's a dependency on someone else's plan — which makes it an assumption with a risk attached (Parts 5, 8).

## Part 3 — Defining success criteria

1. **Convert the objective into observable, checkable criteria** — the project-level equivalent of acceptance criteria: "analysts run their own queries (≥20 weekly actives by end of Q2)", "request-cycle time under 1 day", "zero data-team involvement for standard reports". Each criterion must be measurable by a named method; a criterion nobody can check is a wish.
2. **Include the quality floors from Part 2** as criteria, so "done fast but broken" can't pass.
3. **Define levels:** *minimum success* (the project was worth doing), *target* (the plan aims here), and *stretch* (nice, never at the expense of target). Multi-session projects under uncertainty will face descope decisions; pre-agreed levels turn those from crises into selections (Part 9).
4. **Agree the criteria with the decider before heavy execution** — in writing, in the charter. Criteria negotiated after the work exists are negotiated under duress, by everyone.
5. Success criteria are versioned, not carved: they may change when reality changes (Part 11), but only explicitly, with the change and its reason logged.

## Part 4 — Task decomposition

1. **Decompose top-down by deliverable, not by activity.** First cut: the 3–8 major components/workstreams whose completion *is* the project. Second cut: within each, tasks that end in observable results ("schema deployed and migration tested on staging copy" — not "work on database"). Activity-shaped tasks ("research", "coordinate") are re-shaped until they name their output ("decision memo comparing X/Y with recommendation").
2. **Decompose to different depths by proximity.** Detail the next 1–2 milestones finely (tasks of a session or less); leave later phases coarse (deliverable-level). Fine-grained planning of distant work is waste — it will be re-planned anyway once nearer unknowns resolve — and its false precision hides how little is actually known. This is rolling-wave planning; re-detail each wave as it approaches.
3. **Make investigation tasks first-class** (standing rule 2): every significant unknown ("can the vendor API handle our volume?", "is the legacy data clean enough?") becomes a named task with a deliverable ("load-test memo", "data-quality report") — scheduled *before* the work that depends on the answer.
4. **Each task carries, at minimum:** its deliverable, its verification ("done when…"), its dependencies (Part 5), and a rough size (small/medium/large is enough; false precision in estimates is a project disease — see Part 7.4).
5. **Cap open granularity.** The live task list holds what's active plus the next wave; everything else stays at milestone level. A 400-item flat list is unmaintainable and therefore, within weeks, false.

## Part 5 — Dependency analysis

1. **Map dependencies explicitly for the detailed wave:** for each task, what must exist before it can start, and what waits on it. Record it in the task entry ("blocked by: T-12, vendor API access"). For most projects a blocked-by list per task beats a formal graph; build the visual graph only when the web gets genuinely tangled.
2. **Find the critical path — the longest dependency chain to the objective** — and mark it. Delay on this chain is delay to the project; slack anywhere else is not. Prioritization (Part 6), risk (Part 8), and tracking (Part 10) all treat critical-path items differently.
3. **Distinguish dependency types, because they're managed differently:** *internal* (own sequencing — manage by ordering), *external* (other teams, vendors, approvals — manage by early requests, dates in writing, and named fallbacks; external dependencies are the top source of multi-session project delay and get chased *before* they're due, not after), and *assumed* (work sequenced on an unverified belief — convert to an investigation task or accept and log the risk).
4. **Break dependencies where cheap.** Ask of each blocking edge: can a stub, a mock, a simplified interim version, or an interface-agreement-in-writing decouple these? A one-day stub that unblocks three weeks of parallel work is the best trade in project management.
5. **Re-run the analysis at every wave re-detail and every plan adaptation (Part 11)** — dependency maps rot faster than any other artifact.

## Part 6 — Prioritization

1. **Priority = value × urgency × unblocking power ÷ cost — applied after risk-ordering.** The overriding rule for uncertain projects: **do the riskiest-assumption work first** (Part 4.3). Nothing outranks finding out early that the plan can't work.
2. **Critical-path tasks beat off-path tasks** of equal appeal; off-path work is what fills genuine waiting time, not what displaces path work.
3. **Weigh unblocking power explicitly:** a small task that unblocks three others or another person outranks a larger isolated one. In multi-workstream projects, keeping others unblocked is often the single highest-value use of a session.
4. **Sequence some visible value early.** A thin end-to-end slice (skeleton walking through all components) beats depth-first perfection of one component: it validates the architecture, gives stakeholders something real, and converts integration risk — the classic late killer — into early information.
5. **Say no in writing:** deprioritized and rejected items go to a logged backlog with one-line reasons. Silent deprioritization is how stakeholders discover disagreements at delivery time.

## Part 7 — Milestone planning

1. **Milestones are verifiable states, not dates on activities:** "end-to-end slice demoed on staging with real data" — a claim that is true or false on inspection. Each milestone lists the 2–5 checks that constitute passing it.
2. **Space milestones by decision value:** each should answer a question or retire a risk ("architecture holds", "data is clean enough", "users will adopt"). A milestone that proves nothing is a calendar decoration. For multi-session work, milestones every handful of sessions keep the feedback loop tight.
3. **Put the scariest milestone as early as feasibility allows** — the integration, the load test, the first real-user contact. Projects die of late-discovered bad news; milestone design is where you buy earliness.
4. **Estimate with ranges and buffers, honestly:** size in ranges (sessions/weeks, not hours), add explicit buffer *at the project level* (not padded into each task, where it hides), and expect the uncomfortable truth that novel work routinely takes 1.5–3× first estimates — plan the critical path with that multiplier, and treat estimate misses as calibration data for the next wave (Part 10.4), not as sins.
5. **Every milestone review is a go/adjust/stop decision, on the record:** met (evidence attached) → proceed; missed → diagnose (estimation error? new information? assumption death?) and re-plan the wave (Part 11) — never silently slide the date and change nothing else, which is the signature move of failing projects.

## Part 8 — Risk assessment

1. **Maintain a written risk register from day one:** each entry = the risk stated as an event ("vendor API rate-limits below our volume"), likelihood (high/med/low), impact (high/med/low), an early-warning signal, the response (Part 9), and an owner/next check date. Ten well-chosen entries beat fifty ceremonial ones — register what could actually derail the objective.
2. **Harvest risks from the artifacts you already have:** every assumed dependency (Part 5.3), every soft constraint treated as hard (Part 2.2), every external dependency, every "we'll figure that out later", every unverified estimate on the critical path. The plan documents are a risk-generating machine if read adversarially.
3. **Attach early-warning signals deliberately:** the observable that says the risk is materializing ("vendor response times slipping", "data-quality task finding >5% bad rows"). A risk without a tripwire is discovered only as an incident.
4. **Reduce, don't just record:** the register's purpose is to change the plan — investigation tasks to shrink likelihood (Part 4.3), design choices to shrink impact (decoupling, reversibility), sequencing to buy earliness (Part 7.3). A register that never alters the task list is theater.
5. **Review the register at every milestone and every session handoff touching a risky area:** retire dead risks, add discovered ones, check tripwires. Stale registers are worse than none — they radiate false assurance.

## Part 9 — Contingency planning

1. **Pre-decide responses for the top risks — while calm.** For each high-likelihood-or-high-impact register entry, write the *trigger* (the specific tripwire reading) and the *response*: mitigate (act now to shrink it), fallback (the plan B, with its lead time — a fallback that takes six weeks to activate must be triggered six weeks before it's needed), transfer (someone else absorbs it), or accept (named and signed, not defaulted).
2. **Design descope ladders in advance:** using the success levels from Part 3.3, pre-agree what falls away first under schedule pressure (stretch → target extras → …), and what never does (the quality floors). Descoping under pressure without a pre-agreed ladder is where projects cut the load-bearing parts.
3. **Buy reversibility where it's cheap:** feature flags, parallel-run periods, kept-warm legacy paths, staged rollouts. Contingency is mostly *architecture*, decided early — by the time you need the escape hatch, it's too late to install one.
4. **Hold buffer as buffer.** The project-level buffer (Part 7.4) is spent on materialized risks by decision, not absorbed silently by the first overrunning task. Track its remaining balance in the status doc — buffer burn rate is one of the truest early indicators of project health.
5. **Know the stop condition.** Write down what observation would mean the project should halt or fundamentally pivot (the objective is unreachable within constraints; the assumption the whole thing rests on is dead). Projects without a written stop condition don't stop — they linger. Naming it is what makes invoking it possible (Part 11.5).

## Part 10 — Execution tracking (the multi-session state system)

The project's memory is a small set of living artifacts. Keep them lean enough to actually maintain — a stale tracking system is a false one, and false is worse than absent.

1. **The artifact set (typically one plan document + one task list, or equivalents):**
   - **Charter:** objective, out-of-scope, constraints, success criteria (versioned).
   - **Plan:** milestones with their checks; the detailed current wave; coarse later phases.
   - **Task list:** the live wave — each task with deliverable, "done when", blockers, status. Statuses are factual: *done (evidence linked), in-progress (with next step), blocked (on what, chased when), not started.* "90% done" is banned; a task is done or it isn't — split it if partial credit keeps tempting.
   - **Risk register** (Part 8) and **decision log:** every significant decision as one entry — what was decided, why, what was rejected. The decision log is what prevents multi-session projects from relitigating settled questions and from following forgotten reasoning off a cliff.
2. **Session-start ritual (resume from artifacts, not memory):** read the charter's objective line, the current milestone and its checks, the task list's in-progress and blocked items, the last session's handoff note, and any risk tripwires due. Then state the session's intent — which tasks, toward which milestone — before touching work. If artifacts and recollection disagree, the artifacts win until re-verified.
3. **Session-end ritual (standing rule 3), a written handoff of five lines or so:** what moved (with evidence links), what was learned (especially anything contradicting the plan), what's blocked and on whom, the next best action already identified (Part 12 — deciding it now, with full context, is far cheaper than re-deriving it cold next session), and any risk/decision entries updated.
4. **Track trend, not just state:** milestone dates hit vs. slipped, buffer remaining, estimate accuracy by wave, blocked-task age. Trends are where trouble is visible early — a project can look green on every individual task while its trend line says it's failing.
5. **Report status honestly upward:** progress against milestones (not effort expended), top risks with trend, decisions needed from the decider with options and a recommendation. The report never claims a milestone that hasn't passed its checks.

## Part 11 — Adapting plans when assumptions change

1. **Detect deliberately:** assumption death announces itself through milestone misses, tripwire hits, investigation-task findings, and session learnings (the handoff's "what was learned" line exists for this). Any of these triggers this part — never absorb a broken assumption by quietly working harder.
2. **Size the break before reacting:** does the change invalidate (a) a task (fix locally, log it), (b) the current wave (re-plan the wave: re-decompose, re-run dependencies, re-prioritize — Parts 4–6 on the affected slice), (c) a milestone or the critical path (re-plan + inform the decider with options), or (d) the objective or a success criterion (stop executing; return to Parts 1–3; the decider chooses re-scope, pivot, or stop). Matching the response to the blast radius avoids both panic re-plans and doomed persistence.
3. **Re-plan from reality, not from the old plan:** the question is "given what's now true, what's the best path to the objective?" — not "how do we patch the plan to look intact?" Sunk work is not a reason to preserve a dead approach; say this out loud when reluctance appears.
4. **Log every adaptation:** what broke, what was known when the plan was made, what changed, the new shape — in the decision log, with success-criteria versions bumped if touched (Part 3.5). Adaptation without a record becomes drift; with a record it becomes learning, and it keeps stakeholders' picture true.
5. **Check the stop condition (Part 9.5) at every level-(c) or level-(d) adaptation.** Invoking a written stop condition on evidence is a successful outcome of good tracking — materially better than the alternative, which is the same stop later, plus the burn.

## Part 12 — Determining next best actions

At every session start and after every completed task, choose the next action by this cascade (take the first branch that fires):

```
1. Is a risk tripwire firing, or a contingency trigger met?
      → execute the pre-decided response (Part 9). Nothing outranks a firing trigger.
2. Is anything blocked on YOU that unblocks others (people or workstreams)?
      → unblock them. Throughput of the whole beats progress of the part.
3. Is an external dependency due for chasing (Part 5.3)?
      → chase it now; the lead time you protect is critical-path time.
4. Does the current milestone have an unresolved riskiest-assumption /
   investigation task (Part 4.3)?
      → do it before dependent build work. Finding out beats building on hope.
5. Is there critical-path work ready (unblocked, in the current wave)?
      → the highest-priority such task (Part 6).
6. Otherwise → off-path work by priority, or wave re-detailing (Part 4.2),
   or register/plan maintenance — in that order.
```

Two overrides: **(a) finish before starting** — an in-progress task at 80% usually beats a fresh start at 0%, because open work carries switching cost and decays (exception: it's blocked, or a higher branch fired); **(b) momentum is not a reason** — "it's what I was doing" justifies nothing; the cascade re-runs from the top each time, and its answer sometimes is "stop building and go re-plan," which must be as executable as any task.

---

## Worked micro-example (one project, compressed)

Project: "Replace the legacy reporting system" — ~3 months, many sessions, real uncertainty.

- **P1–3:** Objective interrogated: not "replace" but "finance closes the month without manual spreadsheet reconciliation" (the stated solution and the objective recorded separately). Decider: finance director. Out-of-scope written: historical re-statements. Success levels: minimum = month-end close runs on new system in parallel with legacy, matching to <0.1%; target = legacy off; stretch = self-serve dashboards.
- **P2, P8:** Binding constraint verified: fiscal-year cutover date is contractual (hard). "Legacy DB schema is documented" — exposed as an assumption, not a fact → risk register + investigation task.
- **P4–5:** Wave 1 detailed; later phases coarse. Riskiest assumptions become tasks: schema-archaeology memo; sample-month reconciliation spike. External dependency (DBA access) requested in writing, week 1, with chase dates. A stub of the legacy extract unblocks report-building in parallel.
- **P6–7:** Thin slice scheduled early: one report, end-to-end, real data — the scariest milestone third, not last. Buffer held at project level; critical path estimated with the novelty multiplier.
- **P10:** Every session ends with the five-line handoff. Session 9's learning line: "spike found undocumented triggers mutating totals" — a plan-level break.
- **P11:** Sized as level (c): critical path affected. Re-planned from reality: parallel-run period extended, stretch dashboards moved below the line per the pre-agreed descope ladder; decider informed with options; decision logged. The old plan is not patched to look intact.
- **P12 in action:** next session opens with the cascade: no tripwires → DBA access due for chasing (branch 3) → chased before any build work — protecting the path beats visible progress.
- **Close:** minimum-success criteria pass their checks in parallel run (evidence linked); legacy off two weeks into buffer, whose burn was tracked and spent by decision. The decision log shows four adaptations, zero relitigated.

The signature of the method: the project's worst surprise (session 9) cost a re-plan, not the project — because the assumption had a name, the descope ladder pre-existed, and the state lived in artifacts that made the adaptation cheap to reason about and honest to report.
