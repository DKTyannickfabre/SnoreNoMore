---
title: SnoreNoMore — Product Requirements Document
status: final
created: 2026-08-30
updated: 2026-08-30
author: John (Product Manager, BMAD)
product: SnoreNoMore (snorelab-local)
type: retro-spec PRD (formalizes an already-shipped product)
sources:
  - ../../../SEED.md
  - ../../../_bmad-output/specs/spec-snorenomore/SPEC.md
  - ../../../_bmad-output/specs/spec-snorenomore/stack.md
  - ../../../_bmad-output/specs/spec-snorenomore/RETROSPECTIVE-round-1.md
  - ../../../snorelab-local/index.html
  - ../../../snorelab-local/manifest.json
---

# SnoreNoMore — Product Requirements Document

> **Nature of this document.** SnoreNoMore is already built, shipped as a single static
> deliverable (`snorelab-local/index.html` + `manifest.json`), and was judged outcome-met in
> loop round 1. This PRD is written *after the fact* to formalize the product: it states the
> problem, goals, users, and success metrics, and turns the six canonical capabilities
> (CAP-1..CAP-6) into numbered functional and non-functional requirements that the current
> build already satisfies. It also carries a prioritized next-increment backlog. Requirements
> here describe the intended, shipped behavior — not net-new work — except in
> [§10 Next Increment](#10-next-increment-prioritized-backlog).

---

## 1. Overview

SnoreNoMore is a 100%-local Progressive Web App (PWA) that lets a habitual adult snorer run a
nightly closed loop to understand and reduce their snoring. It follows SnoreLab's proven domain
method — **Measure → Quantify → Correlate → Feedback**:

- **Measure** — the phone microphone records all night and classifies audio by intensity.
- **Quantify** — the night is scored into a Snore Score (0–10), Time Snoring, and Snore %.
- **Correlate** — the user tags the remedies and lifestyle factors in play that night.
- **Feedback** — a 7-day Trends view compares a chosen remedy's average score ON vs OFF.

Everything runs on-device in mobile Safari (Add to Home Screen, standalone). No backend, no
accounts, no cloud, no `npm install`. **SnoreNoMore is not a medical diagnostic tool.**

---

## 2. Problem

Habitual adult snorers who sleep with a phone on the nightstand face two intertwined gaps:

1. **They don't know how much they snore.** Snoring happens while they're asleep; a bed partner's
   complaint is anecdotal and unquantified.
2. **They don't know what actually helps.** They try remedies (side sleeping, nasal strips,
   mouth tape, avoiding late alcohol) but have no evidence-grounded way to tell whether any of
   them changed anything.

The result is guesswork. SnoreNoMore closes the loop with an objective nightly measurement and a
plain ON-vs-OFF comparison, so behavior change is driven by the user's own data rather than by a
hunch or a partner's frustration.

---

## 3. Goals & Non-Goals

### 3.1 Goals

- **G1 — Frictionless nightly measurement.** Get a snorer from opening the app to a running
  recording in under 10 seconds, capturing their remedy/factor context for the night.
- **G2 — An objective, comparable score.** Reduce a night of audio to a single Snore Score (0–10)
  plus Time Snoring and Snore %, so nights are comparable to each other.
- **G3 — Evidence for behavior change.** Show, per remedy, whether nights with it ON scored lower
  on average than nights with it OFF — the actionable feedback that drives change.
- **G4 — Absolute privacy by construction.** Keep all audio and data on-device; make it
  impossible for a night's data to leave the phone.
- **G5 — Zero-install reach.** Ship as a static PWA that runs on an iPhone SE-class device with no
  backend and no build step.

### 3.2 Non-Goals (verbatim from the seed)

- No sleep apnea diagnosis, no AHI calculation, no CPAP device control.
- No user accounts, login, cloud sync, or social sharing.
- No real-time snore intervention (no vibration, no loud sound to stop snoring).
- No app store build, no Trends beyond 7/30 days, no Discover/Settings full implementation.

---

## 4. Target User

**Primary persona — "Dan, the frustrated snorer."** An adult who has been told he snores, sleeps
with an iPhone on the nightstand, and is willing to experiment with cheap remedies but wants proof
before committing. He is health-curious, not a patient; he wants a lifestyle tool, not a clinical
device. He values privacy and is wary of uploading sleep audio to a cloud service.

**Anti-persona — the clinical user.** Someone seeking an apnea diagnosis or an AHI number. The
product explicitly redirects this user to a doctor and does not serve their need. `[ASSUMPTION A5]`

---

## 5. Success Metrics

Grounded in the frozen OUTCOME. Because the product is fully local with no analytics backend
(a deliberate privacy choice), these metrics are **acceptance/judge-observable** signals verified
on-device, not server-side telemetry.

| ID | Metric | Target | How observed |
|----|--------|--------|--------------|
| M1 | Time-to-record | < 10 s from opening Setup to a running night | Manual/judge timing on iPhone SE viewport |
| M2 | Loop completeness | 100% of the Measure→Quantify→Correlate→Feedback loop completable end-to-end at a desk | Demo/simulate path exercises all six capabilities |
| M3 | Score legibility | On stop, Snore Score + Time Snoring + Snore % + segmented timeline visible without extra taps | Detail view inspection |
| M4 | Correlation clarity | Selecting a remedy in Trends renders ON-vs-OFF average scores with an honest verdict | Trends view inspection |
| M5 | Privacy guarantee | Zero network egress of audio or night data | Source audit: no `fetch`/`XHR`/`sendBeacon`/`WebSocket` upload paths |
| M6 | Compliance presence | Disclaimer visible on Setup, Detail, and Trends | UI inspection |

**Counter-metrics (guardrails against gaming the above):**

- **C1 — No false "it helps."** A remedy must not be presented as helping when the ON/OFF
  comparison rests on too few nights to be meaningful (addressed by [§10](#10-next-increment-prioritized-backlog) BA-1/BA-2).
- **C2 — Speed not bought with data loss.** The <10 s target (M1) must never come at the cost of
  dropping the user's remedy/factor/delay selections for the night.
- **C3 — Demo honesty.** The simulate path that makes M2 desk-demonstrable must be visibly
  distinguishable from real measured data (addressed by [§10](#10-next-increment-prioritized-backlog) BA-4).

---

## 6. Domain Method & Authoritative Quantification

SnoreNoMore is a faithful implementation of the **Measure → Quantify → Correlate → Feedback**
loop. The quantification formulas below are **authoritative** — the shipped app computes exactly
these, and any future change must preserve them.

```
timeInBed   = end − start − delay
timeSnoring = Σ( Light + Loud + Epic  durations )
snorePct    = timeSnoring / timeInBed
snoreScore  ∈ [0, 10]   normalized from timeSnoring + loudness
                        (0–1 = minimal … 7–10 = heavy)
```

Where:

- `start` / `end` — night recording start and stop timestamps.
- `delay` — the fall-asleep delay window (5/10/15/20/30 min) during which recording is suppressed.
- Intensity levels — every audio interval is classified **Quiet / Light / Loud / Epic / Noise**;
  only **Light + Loud + Epic** count as snoring. **Quiet** and **Noise** (non-snore sound) are
  excluded from `timeSnoring`. Loudness **spikes** (peaks) are captured per segment.

A persisted **night record** carries: `id`, `start`, `end`, `delayMinutes`, `remedies[]`,
`factors[]`, `segments[]` (each `{tStart, tEnd, level, peak}`), and the derived `timeInBed`,
`timeSnoring`, `snorePct`, `snoreScore`.

---

## 7. Functional Requirements

Requirements are grouped by capability (CAP-1..CAP-6) and carry globally-unique, stable IDs.
All FRs describe behavior the current build already delivers.

### 7.1 CAP-1 — Nightly setup & tagging

- **FR-1** The app SHALL present a **searchable multi-select** of Remedies (e.g. Side Sleeping,
  Nasal Strip, CPAP, Mouthpiece, Mouth Tape, SnoreGym) and lifestyle Factors (e.g. Alcohol,
  Exhaustion, Four Hour Fast, Ate Late, Blocked Nose, Weight).
- **FR-2** The multi-select SHALL enforce a cap of **up to 3 remedies and up to 2 factors** per
  night, with **checkmarks** on selected items and a **live Confirm count**.
- **FR-3** Each tag SHALL expose an **info affordance** (long-press) describing what it is.
- **FR-4** The app SHALL provide a **fall-asleep delay picker** with options **5 / 10 / 15 / 20 /
  30 minutes**; recording is suppressed during this window.
- **FR-5** The app SHALL provide an **optional Soundscape toggle** for the night.
- **FR-6** A **Start** control SHALL begin the night recording, capturing the selected delay,
  remedies, and factors; Start SHALL be reachable in **under 10 seconds** from opening Setup.

### 7.2 CAP-2 — All-night capture & intensity classification

- **FR-7** The app SHALL capture audio via the phone microphone (`getUserMedia` + Web Audio) for
  the duration of the night.
- **FR-8** The app SHALL **suppress recording during the fall-asleep delay window** (FR-4).
- **FR-9** The app SHALL classify captured audio into **Quiet / Light / Loud / Epic / Noise**
  segments and capture loudness **spikes**, computed **entirely on-device**.
- **FR-10** A completed night SHALL yield a **segmented intensity timeline with spikes**.
- **FR-11** The app SHALL provide a **demo / simulate path** (accelerated or synthetic night) so
  the full loop is demonstrable end-to-end at a desk, **without** weakening the real mic path or
  sending audio anywhere.

### 7.3 CAP-3 — Morning quantification & night detail

- **FR-12** On **Stop**, the app SHALL compute `timeInBed`, `timeSnoring`, `snorePct`, and
  `snoreScore` using the authoritative formulas in [§6](#6-domain-method--authoritative-quantification).
- **FR-13** Immediately on stop, the app SHALL present that night's **Snore Score** (as a
  **circular score**), **Time Snoring + Snore %**, and the **segmented timeline**.
- **FR-14** The night detail view SHALL include an **hourly graph with a legend**, and display
  **Time in Bed** and **Time Snoring**.
- **FR-15** The night detail view SHALL include a **BreathFlow upgrade placeholder**.

### 7.4 CAP-4 — Results history

- **FR-16** The app SHALL **persist each night locally** (in `localStorage`, under a single
  namespaced key).
- **FR-17** The Results view SHALL list past nights **grouped by month**.
- **FR-18** Each result row SHALL show a **mini-timeline**, **remedy/factor icons**, and a
  **circular score**.
- **FR-19** Selecting a result row SHALL open its **CAP-3 detail view**.

### 7.5 CAP-5 — 7-day Trends correlation

- **FR-20** The Trends view SHALL aggregate the **last 7 days** (a 7/30-day toggle is permitted).
- **FR-21** The user SHALL be able to **select any tagged remedy** to compare **average Snore
  Score with the remedy ON versus OFF**.
- **FR-22** The ON-vs-OFF comparison SHALL render an **honest verdict** of whether the remedy
  appears to help, with correct **empty-state gating** when a side (ON or OFF) has no nights.

### 7.6 CAP-6 — Compliance & privacy

- **FR-23** The UI SHALL display the disclaimer **"Not medical advice. For apnea risk see
  doctor."** — visible on Setup, Detail, and Trends.
- **FR-24** The app SHALL make **no diagnosis claims** (no apnea diagnosis, no AHI).
- **FR-25** The app SHALL raise **no real-time anti-snore alarm** and take no action that wakes
  the user.
- **FR-26** **All audio and night data SHALL remain on-device** — no network or cloud call may
  carry audio or night data.

---

## 8. Non-Functional Requirements

- **NFR-1 — Platform.** The app SHALL run **100% locally in mobile Safari on iPhone SE 2023
  (375×667)**, installable via **Add to Home Screen** as a **standalone** PWA.
- **NFR-2 — Zero-install delivery.** The app SHALL be a **single static deliverable**
  (`index.html` + `manifest.json`) requiring **no backend and no `npm install`**, runnable when
  served at `http://localhost:8000`.
- **NFR-3 — Stack.** Implemented as a **React/Preact single-page app** with **Tailwind-style
  utility classes** and **lucide icons**; **no external native plugins**; no bundler/build step
  (CDN-loaded). See `stack.md`.
- **NFR-4 — Privacy.** Audio **never leaves the device**; **no cloud upload**; **no PHI** in logs
  or `localStorage` beyond session/night data.
- **NFR-5 — Compliance framing.** The product positions itself as a lifestyle/measurement tool,
  **not** a medical device; disclaimer per FR-23 is always present.
- **NFR-6 — Performance / responsiveness.** Setup-to-record within 10 s (M1); the UI SHALL remain
  responsive on the target device throughout an all-night capture. `[ASSUMPTION A1]`
- **NFR-7 — Offline-first.** Because there is no backend, the app SHALL function with **no network
  connection** after first load. `[ASSUMPTION A2]`
- **NFR-8 — Data durability.** Night records SHALL survive app restarts via `localStorage`; the
  app SHALL degrade gracefully (not crash) if storage is unavailable or full. `[ASSUMPTION A3]`
- **NFR-9 — Accessibility target.** The UI targets the iPhone SE viewport with tap-friendly
  controls; broader a11y parity (e.g. non-long-press affordances) is tracked in
  [§10](#10-next-increment-prioritized-backlog) UX-3. `[ASSUMPTION A4]`

---

## 9. Navigation & Key Screens

A tab/section shell covering at least:

- **Record** — Setup (tagging, delay, soundscape) + live recording.
- **Results** — history grouped by month → night Detail (circular score, segmented timeline,
  hourly graph + legend, Time in Bed / Time Snoring, BreathFlow placeholder).
- **Trends** — 7-day (7/30 toggle) remedy ON-vs-OFF correlation.

The disclaimer (FR-23) is present on Setup, Detail, and Trends.

---

## 10. Next Increment (Prioritized Backlog)

Eight non-blocking improvements identified by the round-1 judges. None affect the accepted OUTCOME;
they raise trust, honesty, and accessibility. Priority reflects user-visible payoff vs. effort.

| Priority | ID | Item | Rationale |
|----------|-----|------|-----------|
| **P1** | BA-1 | Enforce a **minimum nights-per-side threshold** before any "helps" claim | Prevents false positives from tiny samples (guardrail C1) |
| **P1** | BA-2 | Show **sample-size honesty** (spread/confidence) alongside ON/OFF averages | Makes the Trends verdict trustworthy (guardrail C1) |
| **P1** | UX-1 | Trends **defaults to a remedy that has both ON and OFF nights** | First-run Trends shows a meaningful comparison, not an empty state |
| **P2** | UX-3 | Make the **(i) tag info icon tappable**, not long-press only | Accessibility parity (NFR-9) |
| **P2** | BA-4 | **Clarify demo vs. real** measured variance in synthetic data | Demo honesty (guardrail C3) |
| **P2** | BA-3 | **De-dupe / label multiple same-day nights** | Correct aggregation when a user records more than once a day |
| **P3** | UX-2 | **Mic-permission priming** reinforcing on-device + <10 s feel | Reduces permission drop-off; reinforces privacy story (G4) |
| **P3** | UX-4 | **Tap-to-inspect spike times** on timeline / hourly bars | Deeper night insight for engaged users |

---

## 11. Assumptions & Open Items

All decisions below were made autonomously (no user available) as the most faithful reading of the
seed, spec, stack, and shipped build. Each is recorded in the run memlog.

- **[ASSUMPTION A1]** "Responsive during all-night capture" is an implied NFR; the seed/spec name
  only the <10 s setup target explicitly.
- **[ASSUMPTION A2]** Offline-first is inferred from "no backend / 100% local"; the seed does not
  state offline behavior in those words.
- **[ASSUMPTION A3]** Graceful degradation on storage failure is an inferred robustness NFR, not an
  explicit seed requirement.
- **[ASSUMPTION A4]** The a11y target is scoped to the stated iPhone SE viewport; full WCAG
  conformance is out of scope for this lifestyle tool.
- **[ASSUMPTION A5]** The clinical "anti-persona" is inferred from the compliance stance ("For
  apnea risk see doctor"); the seed names the primary snorer persona only.
- **[ASSUMPTION A6]** Success metrics are framed as judge/acceptance-observable because the
  privacy constraint (NFR-4) forbids an analytics backend — no server-side KPIs are possible.

**Open questions (deferred, non-blocking):** none block downstream work. The backlog in
[§10](#10-next-increment-prioritized-backlog) is the sanctioned home for the next increment.

---

## 12. Traceability

| Capability | FRs | Success signal (from SPEC) |
|-----------|-----|----------------------------|
| CAP-1 Setup & tagging | FR-1..FR-6 | Record starts <10 s with selections captured |
| CAP-2 Capture & classification | FR-7..FR-11 | Segmented timeline with spikes, on-device |
| CAP-3 Quantify & detail | FR-12..FR-15 | Score + Time Snoring + % + timeline on stop |
| CAP-4 Results history | FR-16..FR-19 | Nights grouped by month, open to detail |
| CAP-5 Trends correlation | FR-20..FR-22 | Remedy ON-vs-OFF averages shown |
| CAP-6 Compliance & privacy | FR-23..FR-26 | Disclaimer visible; no data egress |

**Requirement count:** 26 functional (FR-1..FR-26) + 9 non-functional (NFR-1..NFR-9) = **35
requirements**, plus 6 success metrics (M1..M6), 3 counter-metrics (C1..C3), and 8 backlog items.
