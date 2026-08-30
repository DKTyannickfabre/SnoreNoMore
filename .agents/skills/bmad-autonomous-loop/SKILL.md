---
name: bmad-autonomous-loop
description: 'Fully autonomous, outcome-driven SDLC loop over bmad-spec, bmad-build-auto, and bmad-retrospective with no human gates. Pins an immutable desired OUTCOME from the seed, then lets an emergent multi-agent cast (architect, dev, plus UX-designer and business-analyst judges) refine the idea into functions, architecture, code, and tests round after round. Two independent AI judges evaluate the running app against the outcome, autonomously augment the spec, and re-feed the loop until both judge the outcome met — or a safety circuit breaker trips. Use when the user says "run the autonomous loop", "iterate until satisfied", "keep building and refining until done", "achieve this outcome autonomously", or asks for a closed-loop / self-improving / hands-off build cycle.'
---

# BMad Autonomous Loop

## Purpose

No shipped BMad skill chains spec → build → judge → refine together; each is a well-behaved worker built to be *driven*, not a driver. This skill is that driver, run **fully autonomously**: once seeded, it takes no human input until it stops. It performs no spec/build/retro work itself — it drives `bmad-spec`, autonomous story synthesis, `bmad-build-auto`, `bmad-retrospective`, and two independent judge agents, carrying structured state between rounds so the loop resumes instead of restarting.

The human's only contribution is the **seed and its outcome**. Every decision that shipped BMad reserves for a human — story checkpoints, HALT resolutions, the acceptance verdict — is delegated here to an agent. The emergent signal comes from role separation: a builder cast (architect, dev) that wants to ship, and a judge cast (UX designer, business analyst) that independently tests the result against the outcome and refuses to rubber-stamp. Their disagreement is the refinement engine.

This runs for as long as the current session keeps executing it. It is not a background daemon — nothing continues after the session ends.

## The Outcome contract — the immutable north star

The seed's most important element is the **desired outcome**: the observable end-state that means "done." At round 1 the loop pins this as `outcome:` in the ledger, verbatim from the seed, and it is **frozen** — no round, no agent, no judge may edit, soften, or reinterpret it. Everything else (capabilities, architecture, stories, code) is mutable and exists only to serve the outcome.

This freeze is the loop's anti-drift invariant. An autonomous loop with a mutable goal optimizes itself into triviality; a frozen outcome forces the work to move toward the target instead of moving the target toward the work. If the judges conclude the outcome as stated is genuinely unreachable, they do **not** rewrite it — they trip the `infeasible` circuit breaker (see Safety) and the loop stops and reports, rather than silently declaring victory on a redefined goal.

## Preconditions — establish once, at round 1

Fully autonomous means minimal preconditions, gathered once, never revisited mid-loop:

1. **The seed** — the initial idea in any shape (pasted text, file, path, existing spec folder).
2. **The outcome** — the observable success state the judges test against. If the seed does not carry a testable outcome, derive the most faithful one from the seed and record it in the ledger as `outcome_source: derived` so the assumption is auditable; only ask the human if the seed is too thin to derive any outcome at all.
3. **Scope** — target repo/folder and greenfield vs brownfield, inferred from the seed/workspace when possible.
4. **Safety envelope** — the circuit breakers below are *always on* with defaults; the human may tighten them but the loop supplies them itself. These are guardrails, not gates: they stop a runaway or divergent loop, they never pause it for a decision.

The loop does not require a human-chosen stopping condition. The stop authority is the dual-judge consensus plus the safety circuit breakers — that is the whole point of removing the human.

## The agent cast

Each round invokes agents as **independent subagents** (parallel where marked). Independence is load-bearing: judges that share a context groupthink, and the emergent refinement signal collapses. Never let one agent both build and judge the same artifact in the same round.

| Role | Skill / agent | Job |
|---|---|---|
| Distiller | `bmad-spec` | Turn seed + augmentations into the SPEC kernel; owns capability IDs. |
| Story synthesizer | this loop (see below) | Autonomously derive `stories.yaml` — replaces the human story gate. |
| Builder | `bmad-build-auto` | Implement one story per invocation across the SDLC (design→code→test). |
| Build-quality judge | `bmad-retrospective -H` | Evidence-based verdict on *how well the epic was built*. |
| Outcome judge — UX | subagent `bmad-agent-ux-designer` | Exercise the running app; judge experience/usability against the outcome. |
| Outcome judge — BA | subagent `bmad-agent-analyst` | Exercise the running app; judge whether it delivers the outcome's value. |

## State ledger — structured, machine-readable

Maintain `{output_folder}/specs/spec-{slug}/.loop-ledger.yaml` (structured, not prose, so resume is deterministic). Create it at round 1; append a round record every round. Read it first at the start of every round — it is how the loop resumes correctly instead of re-deriving state.

```yaml
outcome: "<frozen verbatim north star>"
outcome_source: seed | derived
slug: <spec slug>
branch: loop/<slug>            # dedicated working branch; main is never built on directly
round_cap: 8
rounds:
  - n: 1
    round_tag: loop-round-1     # git tag at round start, for rollback
    capabilities_added: [CAP-1, CAP-2]
    stories: [{id: S1, status: done}, {id: S2, status: blocked}]
    retro_verdict: accepted-with-open-items
    retro_archive: RETROSPECTIVE-round-1.md
    judges:
      ux:  {outcome_met: false, score: 0.6, blocking: [UX-3]}
      ba:  {outcome_met: false, score: 0.5, blocking: [BA-1, BA-2]}
    open_blocking_count: 3       # convergence signal — must trend down
    actioned_refs: [BA-1, UX-3]  # dedupe key across rounds
    decision: continue           # continue | stop-accepted | stop-circuit-breaker
    reason: "judges not yet in consensus; blocking items shrinking 5→3"
```

## Round structure — autonomous

Repeat until a stop condition (dual-judge consensus, or a safety circuit breaker) fires. Every step is unattended.

1. **Commit boundary (open).** Ensure a clean tree on the dedicated `loop/<slug>` branch; commit any loop bookkeeping from the prior round, then tag `loop-round-{n}`. This is what keeps the loop's own writes (ledger, spec, stories) from tripping `bmad-build-auto`'s dirty-tree HALT, and it makes a bad round revertible.
2. **Spec.** Invoke `bmad-spec` against the seed (round 1) or the previous round's deduped judge augmentations (round N+1), pointed at the same spec folder so capability IDs are preserved. Express/headless for gaps — open questions become `assumptions[]`, never a pause. The frozen `outcome` is passed as a fixed constraint; the spec may not restate it as mutable.
3. **Autonomous story synthesis.** `bmad-spec`'s own Story Breakdown is interactive-only and is therefore **not used** here. Instead the loop synthesizes/updates `stories.yaml` itself, directly against `bmad-spec`'s `assets/stories-schema.md`: one story per independently reviewable slice, deriving each `spec_checkpoint` and `done_checkpoint` from the capability's own `success` signal and the frozen outcome rather than asking a human, and writing `invoke_dev_with` dispatch notes from the spec. Validate every entry against the schema before writing; log the verdict. This step is the deliberate autonomous replacement for the human gate — it is the one place this skill supersedes a constituent skill's rule, and it does so explicitly.
4. **Build.** For each story in `stories.yaml` list order not yet `done`, invoke `bmad-build-auto` with folder+id dispatch (`spec_folder` + `story_id`), one invocation per story. `bmad-build-auto` owns the inner SDLC (design, code, test) for that story. Resolve HALTs autonomously per the policy below — never pause for a human.
5. **Commit boundary (close).** When the round's dispatched stories reach `done`, commit the build. A story that ends `blocked` is *not* terminal-good: route it to autonomous HALT resolution (below), not to the judges.
6. **Build-quality judgment.** Invoke `bmad-retrospective -H {spec-folder}` (stories mode — pass the folder, not an epic number). Before it runs, archive any existing `RETROSPECTIVE.md` → `RETROSPECTIVE-round-{n-1}.md` so the fixed-name write does not clobber prior evidence; record the archive name in the ledger. Read the verdict (`accepted` / `accepted-with-open-items` / `rejected`) and action items with their `id`/`ref`.
7. **Outcome judgment — dual, independent, parallel.** Invoke `bmad-agent-ux-designer` and `bmad-agent-analyst` as **separate parallel subagents**, each seeded only with: the frozen outcome, the spec, and instructions to *exercise the running app* (not just read code) and return `{outcome_met: bool, score: 0..1, blocking: [ids], augmentations: [spec-ready items]}`. Each judges independently against the outcome with a skeptic default: **not met unless demonstrably achieved by evidence they observed.** They may add capabilities/stories via `augmentations`; they may never touch the frozen outcome. If either judges the outcome unreachable, it returns `infeasible: true` with evidence.
8. **Stop-check.** **Stop-accepted** when both judges return `outcome_met: true` *and* the retrospective verdict is not `rejected` *and* there are no unresolved blocking items. Otherwise evaluate the safety circuit breakers. If neither fires, continue.
9. **Feed forward.** Dedupe this round's retro action items and judge augmentations against `actioned_refs` in the ledger; append only the genuinely new ones as the next round's spec input. Record the round in the ledger (including `open_blocking_count` for the convergence trend). Increment the round counter, go to step 1.

## Autonomous HALT resolution (bmad-build-auto)

`bmad-build-auto` HALTs rather than guessing. With no human in the loop, each HALT is delegated to an agent decision — but the delegation is bounded: agents resolve *engineering ambiguity*, never redefine the frozen outcome, and hard environment limits still stop the loop.

| Blocking condition | Autonomous resolution |
|---|---|
| `unclear intent` | Re-derive intent from the spec + frozen outcome via the architect agent; if still ambiguous after one pass, mark the story `blocked` and hand its ambiguity to the judges as an augmentation — do not guess into code. |
| dirty working tree / `version-control metadata not writable` | Should not occur — the round's commit boundaries own the tree. If it does, commit loop-owned changes and retry once; if metadata is unwritable, trip the `env` circuit breaker (git is a hard dependency). |
| `no stories.yaml found` / `story id not found in stories.yaml` | Re-run autonomous story synthesis (step 3) — never fabricate a lone entry. |
| `ambiguous story file match` / `unrecognized status in existing story file` | Architect agent reconciles against `stories.yaml` list order (authoritative) and the story frontmatter; record the reconciliation in the ledger. |
| `blocked spec supplied` / `story already blocked` | Route the blocker to the judges as a spec augmentation for the next round; leave the story `blocked`, do not force-build. |
| `missing previous-story continuity decision` | Architect agent makes the continuity call from the committed diff of the prior story and records it as an assumption. |
| `context compilation verification failed` | Retry once (idempotent — the round tag bounds side effects); if it fails again, `blocked` + surface to judges. |
| `no subagents` | **Stop the whole loop** (`env` circuit breaker). The dual-judge design *requires* parallel independent subagents; without them there is no autonomous acceptance authority. |

## Safety circuit breakers — the replacement for human oversight

Removing the human removes the natural brake, so these are non-negotiable and always on:

- **Round cap.** Default `8`. Hitting it stops the loop with the current best state, reported honestly as "cap reached, outcome not yet met."
- **Divergence.** If `open_blocking_count` fails to strictly decrease across **2 consecutive rounds**, stop — the loop is churning, not converging. Report the plateau.
- **Zero-progress.** If a round adds no new capabilities *and* no new judge augmentations, the loop is spinning on unchanged code; stop.
- **Infeasibility.** If either judge returns `infeasible: true` with evidence, stop and report that the outcome as stated is unreachable — the loop never rewrites the outcome to manufacture success.
- **Regression rollback.** If a round's combined judge score drops below the prior round's, `git reset` the build to that round's `loop-round-{n}` tag before feeding forward, so a bad round is discarded rather than compounded. Record the rollback.
- **Env.** No subagents, or git unusable → hard stop; these are environment limits, not per-round issues.
- **Budget (optional).** If the human set a token/wallclock box, track approximate spend per round in the ledger and stop when exceeded — an unmeasured budget is not a stop condition.

## Reporting

At the end of every round, whether continuing or stopping, emit one short summary: round number, capabilities/stories added, retro verdict, both judge verdicts with scores, open blocking count and its trend, and the continue/stop decision with its reason. On stop, state which authority stopped it (consensus vs a named circuit breaker) and the final state versus the frozen outcome. Never let a round end silently.

## Constraints

- The **frozen outcome** is inviolable. No agent, judge, retro, or round may edit it. Drift here defeats the whole design.
- **Judge independence is mandatory.** UX and BA judge in separate subagent contexts; a judge never evaluates an artifact it helped build in the same round.
- Party mode / team discussion (retrospective Phase 3) stays skipped — the dual-judge step is this loop's structured, grounded substitute for it.
- All constituent skills' own rules still apply on top of this sequencing — Spec Law, the READY FOR DEVELOPMENT standard, retrospective's evidence-only findings, build-auto's synchronous-subagents-only rule. This skill adds ordering, the frozen outcome, autonomous story synthesis, the dual-judge acceptance authority, and the safety circuit breakers; it relaxes none of the workers' internal guarantees.
- The loop takes no human input after the seed. Everything a human used to decide is delegated to an agent or a circuit breaker — that is the definition of this mode.
