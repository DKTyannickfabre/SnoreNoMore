---
stepsCompleted: [step-01-validate-prerequisites, step-02-design-epics, step-03-create-stories, step-04-final-validation]
inputDocuments:
  - _bmad-output/planning-artifacts/prds/prd-SnoreNoMore-2026-08-30/prd.md
  - _bmad-output/planning-artifacts/ux-designs/ux-SnoreNoMore-2026-08-30/EXPERIENCE.md
  - _bmad-output/planning-artifacts/ux-designs/ux-SnoreNoMore-2026-08-30/DESIGN.md
  - _bmad-output/planning-artifacts/architecture/architecture-SnoreNoMore-2026-08-31/ARCHITECTURE-SPINE.md
increment: "Next Increment — PRD §10 backlog (8 judge-identified items)"
---

# SnoreNoMore - Epic Breakdown

## Overview

This document decomposes the **next increment** of the shipping SnoreNoMore build — the eight
non-blocking, judge-identified backlog items in PRD [§10 Next Increment](prds/prd-SnoreNoMore-2026-08-30/prd.md)
— into epics and implementable stories. Every item is **additive and back-compatible**: all attach
as selectors/UI over the existing canonical night-record contract with **no schema migration** and
**no change to AD-1..AD-11** (per the Architecture *Backlog Landing* table).

All work stays inside the frozen constraints: a **single static deliverable**
(`snorelab-local/index.html` + `manifest.json`), **on-device / zero-egress**, **no build step**
(CDN ESM), targeting **mobile Safari on iPhone SE 2023 (375×667)**.

## Requirements Inventory

### Functional Requirements

The increment items refine, but do not replace, these already-shipped FRs. They are the requirement
anchors the new stories trace back to:

- **FR-3** — Each tag SHALL expose an **info affordance** (currently long-press). *(refined by UX-3)*
- **FR-7** — Capture audio via `getUserMedia` + Web Audio. *(permission flow refined by UX-2)*
- **FR-11** — Provide a **demo / simulate path** that must not masquerade as measured data. *(refined by BA-4)*
- **FR-13 / FR-14** — Present the night's score, timeline, and **hourly graph with legend** in Detail. *(refined by UX-4)*
- **FR-17 / FR-18** — Results lists past nights **grouped by month**, each row with mini-timeline, icons, score. *(refined by BA-3, BA-4)*
- **FR-20** — Trends aggregates the **last 7 days** (7/30 toggle). *(context for UX-1, BA-1, BA-2, BA-3)*
- **FR-21** — User can **select any tagged remedy** to compare **average Snore Score ON vs OFF**. *(refined by UX-1)*
- **FR-22** — The ON-vs-OFF comparison SHALL render an **honest verdict** with correct **empty-state gating**. *(refined by BA-1, BA-2, UX-1)*

### NonFunctional Requirements

- **NFR-1 / NFR-2 / NFR-3** — Single static file, no backend, no `npm install`, no bundler; React/Preact + Tailwind-style utilities + lucide, CDN-loaded; runs at `http://localhost:8000`.
- **NFR-4 / NFR-5** — Audio never leaves the device; no PHI persisted; lifestyle-not-medical framing; disclaimer always present.
- **NFR-6** — Setup-to-record < 10 s; UI stays responsive during all-night capture. *(UX-2 must not add friction to the <10 s path)*
- **NFR-8** — Night records survive restarts via `localStorage`; degrade gracefully if storage is unavailable.
- **NFR-9** — Accessibility target: tap-friendly controls on the iPhone SE viewport; **non-long-press affordances** and ≥44px touch targets. *(directly driven by UX-3, UX-4)*

### Additional Requirements

From the Architecture *Backlog Landing* table — the attach points and invariants every story must respect:

- All eight items are **additive selectors/UI over the existing night-record contract; none needs a schema migration** and none touches AD-1..AD-11.
- **AD-2** — On-device-only, zero egress (reinforced by UX-2 priming copy; nothing new may egress).
- **AD-3** — Aggregate the **persisted `snoreScore`**; never recompute metrics in Trends (BA-1, BA-2).
- **AD-4** — Segments are **0-based** relative to capture start; clock time = `start + delay*60000 + tStart` (UX-4); calendar day derives from `night.start` (BA-3).
- **AD-5** — Level taxonomy + snore membership is the single source of truth; UX-4 reads `level` + `peak` already on each segment.
- **AD-7** — Single persistence namespace / single writer (BA-3 grouping is read-side only).
- **AD-8** — Unidirectional state; views are **pure projections** (all new selectors are derived, not stored).
- **AD-9** — Imperative audio isolated behind refs, outside the render cycle (UX-2 sheet gates the real Start path only).
- **AD-11** — **Simulated data must be self-identifying** (BA-4 strengthens the `simulated` surfacing).
- New shared helper permitted: a **Trends-stats helper beside `computeMetrics`** (BA-1, BA-2). No new global state.

### UX Design Requirements

Extracted from `EXPERIENCE.md` §"Concrete design intent for the eight non-blocking items":

- **UX-DR1 (UX-1)** — On entering Trends, compute the default remedy by scanning the current window for one with **≥1 ON and ≥1 OFF** night (and, once BA-1 lands, meeting `N_min`); prefer the largest combined night count, tie-break by strongest effect; fall back to the most-tagged remedy with the gating line. Selected chip reflects the computed default — no new control.
- **UX-DR2 (UX-2)** — A **one-time priming sheet** (reuse the info-sheet pattern) before the first-ever `getUserMedia`, ordered *what → privacy promise → speed*, buttons **Allow microphone** / **Not now — simulate instead**; only on the real Start path when permission state is `prompt`; skipped if already granted; never before Simulate. Denied state becomes a **sheet** (not a bare `alert`) with a primary **Simulate night** action and a **How to enable in Settings** hint.
- **UX-DR3 (UX-3)** — Guarantee the **(i) info affordance is present and tappable in every tile state, including selected**, with a **≥44px** padded target, `aria-label="About {tag name}"`, and propagation stopped so it never toggles selection; long-press remains only as a redundant shortcut.
- **UX-DR4 (UX-4)** — Make the Detail **timeline** and **hourly graph** interrogable: tapping a segment/spike/bar reveals a lightweight **inspector** showing **clock time** (mapped via `start + delay`), **level**, and **peak**; dismiss on next tap/scroll; each interactive element carries an accessible name (e.g. "Loud spike at 2:14am, peak 0.31"); no layout reflow.
- **UX-DR5 (BA-1)** — Define `N_min` per side (design placeholder **N_min = 2**); below it on either side, **suppress the verdict** and show a neutral status: *"Not enough nights yet — need at least {N_min} with and without {remedy}."* Bars may still render as context, never a "helps/worse" claim.
- **UX-DR6 (BA-2)** — Under each ON/OFF value, show **n** plus a **spread indicator** (thin range whisker or "±X" over that side's nights' `snoreScore`); verdict copy gains a hedge when spread is high ("early signal", not "it helps"); glanceable, not a stats lecture.
- **UX-DR7 (BA-3)** — When >1 night shares a calendar day, Results surfaces a **secondary start–end time label** per row (optionally grouped under a same-day sub-header); Trends treats same-day nights as **distinct** but labels the day once.
- **UX-DR8 (BA-4)** — Strengthen `· sim` into an explicit, consistent **"Simulated" badge** on Detail and Results rows, plus a one-line Detail note: *"Demo data — synthesized to show the full flow, not a real measurement."*

### FR Coverage Map

| Backlog ID | Priority | Epic | Primary FR anchor | Architecture AD | UX-DR |
|---|---|---|---|---|---|
| BA-1 | P1 | Epic 1 | FR-22 | AD-3, AD-8 | UX-DR5 |
| BA-2 | P1 | Epic 1 | FR-22 | AD-3, AD-8 | UX-DR6 |
| UX-1 | P1 | Epic 1 | FR-21, FR-22 | AD-8 | UX-DR1 |
| BA-4 | P2 | Epic 2 | FR-11, FR-13, FR-18 | AD-11 | UX-DR8 |
| BA-3 | P2 | Epic 2 | FR-17, FR-18, FR-20 | AD-4, AD-7, AD-8 | UX-DR7 |
| UX-3 | P2 | Epic 3 | FR-3 | conventions (≥44px), NFR-9 | UX-DR3 |
| UX-4 | P3 | Epic 3 | FR-13, FR-14 | AD-4, AD-5 | UX-DR4 |
| UX-2 | P3 | Epic 4 | FR-7 | AD-2, AD-9 | UX-DR2 |

All eight §10 backlog items are covered. No item is orphaned; no story introduces a schema change.

## Epic List

### Epic 1: Trustworthy Trends
Users can believe the ON-vs-OFF remedy verdict: it never claims "helps" on too-few nights, it shows
how spread-out the evidence is, and it opens on a remedy that actually has both sides — so the first
paint is a meaningful comparison, not an empty prompt.
**Backlog covered:** BA-1, BA-2, UX-1 · **FRs:** FR-21, FR-22 · **ADs:** AD-3, AD-8

### Epic 2: Honest History & Provenance
Users can trust what the history shows: simulated nights are unmistakably labelled as demo data, and
a day recorded more than once is counted correctly instead of silently skewing an average.
**Backlog covered:** BA-4, BA-3 · **FRs:** FR-11, FR-13, FR-17, FR-18, FR-20 · **ADs:** AD-4, AD-7, AD-8, AD-11

### Epic 3: Interaction & Inspection Polish
Engaged users can read what any tag means without deselecting it, and can tap the night's charts to
find exactly when they snored worst — closing the accessibility and inspection gaps NFR-9 calls out.
**Backlog covered:** UX-3, UX-4 · **FRs:** FR-3, FR-13, FR-14 · **ADs:** AD-4, AD-5 · conventions (≥44px)

### Epic 4: Confident First Capture
First-time users meet the microphone prompt with context — what it's for, that audio never leaves the
device, and that recording starts in seconds — and can still complete the loop via Simulate if they
decline, so permission drop-off falls without weakening the privacy story.
**Backlog covered:** UX-2 · **FRs:** FR-7 · **ADs:** AD-2, AD-9 · NFR-6

---

## Epic 1: Trustworthy Trends

Deliver an ON-vs-OFF remedy comparison the user can trust. This epic adds a single new **Trends-stats
helper** beside `computeMetrics` (aggregating the persisted `snoreScore` per AD-3) and gates/annotates
the verdict in the existing `Trends` view (AD-8, pure projection — no new stored state). Stories are
ordered so each builds only on the previous: the threshold predicate lands first, honesty annotations
second, and the smart default (which may consult the threshold) last.

### Story 1.1: Gate the "helps" verdict behind a minimum nights-per-side threshold

As a snorer comparing a remedy,
I want the app to withhold a "helps / doesn't help" claim until I have enough nights on both sides,
So that I'm never misled by a verdict built on one or two nights.

**Acceptance Criteria:**

**Given** a selected remedy in Trends has fewer than `N_min` nights on either the ON side or the OFF side (design placeholder `N_min = 2`)
**When** the ON-vs-OFF comparison renders
**Then** the verdict line is suppressed and replaced with the neutral status "Not enough nights yet — need at least {N_min} with and without {remedy}"
**And** the ON/OFF bars/values may still render as context but no "seems to help/worse" claim appears

**Given** both sides meet or exceed `N_min`
**When** the comparison renders
**Then** the honest verdict is shown as before (FR-22 behaviour preserved)

**Given** the stats are computed
**When** the helper derives ON/OFF aggregates
**Then** it aggregates the **persisted `snoreScore`** of each night and does not recompute night metrics (AD-3)
**And** the threshold logic lives in a new Trends-stats helper beside `computeMetrics`, adding no new stored state (AD-8)

_Traceability: Backlog **BA-1** (P1) · PRD **FR-22** · Architecture **AD-3, AD-8** · UX **UX-DR5**._

### Story 1.2: Show sample-size honesty (n + spread) alongside ON/OFF averages

As a snorer reading the Trends verdict,
I want to see how many nights each average rests on and how spread-out they are,
So that a shaky average built on wildly different nights doesn't read as confident.

**Acceptance Criteria:**

**Given** a remedy's ON and OFF averages are displayed
**When** the comparison renders
**Then** each side shows its **n** (night count) and a **spread indicator** — a thin range whisker or "±X" derived from that side's nights' `snoreScore`

**Given** the spread on a qualifying side is high
**When** the verdict copy renders
**Then** the copy is hedged (e.g. "early signal") rather than asserting "it helps"

**Given** the target viewport is iPhone SE (375×667)
**When** the spread indicators and counts render
**Then** they remain glanceable and cause no horizontal overflow or layout break
**And** the spread is computed in the same Trends-stats helper over persisted `snoreScore` values (AD-3), with no new stored state (AD-8)

_Traceability: Backlog **BA-2** (P1) · PRD **FR-22** · Architecture **AD-3, AD-8** · UX **UX-DR6**._

### Story 1.3: Default Trends to a remedy that has both ON and OFF nights

As a snorer opening Trends for the first time,
I want it to start on a remedy that actually has nights with and without it,
So that my first view is a meaningful comparison instead of an empty or one-sided prompt.

**Acceptance Criteria:**

**Given** the current window contains at least one remedy with ≥1 ON and ≥1 OFF night
**When** Trends is entered
**Then** the default selected remedy is the qualifying one with the **largest combined night count**, tie-broken by strongest effect
**And** once BA-1 has landed, the default preferentially picks a remedy meeting `N_min` on both sides
**And** the selected chip reflects the computed default with no new control added

**Given** no remedy in the window has both sides
**When** Trends is entered
**Then** it defaults to the most-tagged remedy and shows the BA-1 gating line rather than an accidental empty comparison

**Given** the default is computed
**When** the view renders
**Then** the selection is a pure derivation over `nights` (AD-8) and persists no extra state

_Traceability: Backlog **UX-1** (P1) · PRD **FR-21, FR-22** · Architecture **AD-8** · UX **UX-DR1**._

---

## Epic 2: Honest History & Provenance

Make the history honest and correctly aggregated. This epic strengthens the self-identification of
simulated nights (AD-11) across Detail and Results, and makes same-day nights visibly distinct in
Results while keeping Trends aggregation correct. All changes are read-side projections over the
existing persisted records (AD-7, AD-8) — no writes, no schema change.

### Story 2.1: Mark simulated nights with an explicit "Simulated" badge and note

As a user reviewing a night,
I want synthetic demo nights to be clearly labelled as simulated,
So that I never mistake demo data for a real measurement.

**Acceptance Criteria:**

**Given** a night has `simulated === true`
**When** its row renders in Results and its Detail view opens
**Then** an explicit, consistent **"Simulated" badge** (simulate-tint) is shown, replacing/upgrading the prior `· sim` marker

**Given** a simulated night's Detail is open
**When** the view renders
**Then** a one-line note reads "Demo data — synthesized to show the full flow, not a real measurement"

**Given** a night was really measured (`simulated` falsy)
**When** its Detail and Results row render
**Then** no Simulated badge or demo note appears

**Given** existing persisted nights predate a `simulated` flag
**When** they render
**Then** the app degrades gracefully (absence of the flag is treated as not-simulated) with no crash and no schema migration (AD-11, back-compatible)

_Traceability: Backlog **BA-4** (P2) · PRD **FR-11, FR-13, FR-18** · Architecture **AD-11** · UX **UX-DR8**._

### Story 2.2: De-dupe and label multiple same-day nights

As a user who recorded more than once in a day,
I want each night on the same calendar day shown distinctly and labelled by time,
So that a double-recorded day doesn't silently skew my averages or confuse the history.

**Acceptance Criteria:**

**Given** more than one night shares the same calendar day (day derived from `night.start`)
**When** the Results list renders those rows
**Then** each row surfaces a **secondary start–end time label**, and the calendar day is labelled once (optionally as a same-day sub-header)

**Given** same-day nights exist within the Trends window
**When** Trends aggregates ON/OFF
**Then** each same-day night is counted as a **distinct** night (not merged), while the day is labelled once

**Given** the calendar day is determined
**When** grouping runs
**Then** the day is derived from `night.start` (AD-4, 0-based segments mean the day comes from `start`), as a read-only projection with no change to the single writer/namespace (AD-7, AD-8)

_Traceability: Backlog **BA-3** (P2) · PRD **FR-17, FR-18, FR-20** · Architecture **AD-4, AD-7, AD-8** · UX **UX-DR7**._

---

## Epic 3: Interaction & Inspection Polish

Close the two interaction gaps NFR-9 flags. This epic hardens the tag info affordance so it is
reachable by a single tap in every tile state (`TagItem`), and makes the Detail charts interrogable so
users can find the clock time of any spike (`Detail`). Independent components, independent stories.

### Story 3.1: Make the (i) tag info tappable in every tile state

As a user selecting remedies and factors,
I want to tap the (i) on any tag — even one I've already selected — to read what it is,
So that I can learn what a tag means without deselecting it or discovering a hidden long-press.

**Acceptance Criteria:**

**Given** a tag tile in **any** state, including selected (where a check currently replaces the (i))
**When** the tile renders
**Then** a visible, tappable (i) info affordance is present (alongside/behind the check, or as a persistent leading affordance)

**Given** the (i) affordance
**When** the user taps it
**Then** the tag's info opens **and** selection state is unchanged (tap propagation is stopped so it never toggles the tag)

**Given** the iPhone SE touch target guidance
**When** the (i) renders
**Then** it exposes a **≥44px** padded hit area and an `aria-label="About {tag name}"`

**Given** long-press was the prior affordance
**When** the change ships
**Then** long-press still works as a redundant shortcut but is never the sole path (satisfies NFR-9, refines FR-3)

_Traceability: Backlog **UX-3** (P2) · PRD **FR-3** · Architecture conventions (≥44px), **NFR-9** · UX **UX-DR3**._

### Story 3.2: Tap-to-inspect spike times on the timeline and hourly graph

As an engaged user reviewing a night,
I want to tap a spike or hourly bar to see the exact clock time, level, and peak,
So that I can answer "when did I snore worst?" by tapping the chart, not just reading its shape.

**Acceptance Criteria:**

**Given** the Detail timeline (segments/spikes) or hourly graph is shown
**When** the user taps a segment, spike, or hourly bar
**Then** a lightweight inspector popover reveals the **clock time**, **level**, and **peak** for that point; tapping an hourly bar lists that hour's worst spikes

**Given** the inspector is open
**When** the user taps elsewhere or scrolls
**Then** the inspector dismisses, and no layout reflow occurs at any point

**Given** the tapped point maps to a moment in the night
**When** the clock time is computed
**Then** it is derived as `start + delay*60000 + tStart` using the segment's own `tStart` (AD-4), reading `level` and `peak` already present on the segment (AD-5)

**Given** accessibility on the target viewport
**When** an interactive spike/bar renders
**Then** it carries an accessible name such as "Loud spike at 2:14am, peak 0.31"

_Traceability: Backlog **UX-4** (P3) · PRD **FR-13, FR-14** · Architecture **AD-4, AD-5** · UX **UX-DR4**._

---

## Epic 4: Confident First Capture

Precede the first microphone prompt with context and preserve an honest fallback if the user declines.
This epic adds a one-time priming sheet (reusing the info-sheet pattern) on the real Start path only,
gating `getUserMedia` behind context without touching the audio refs contract (AD-9) or adding any
egress (AD-2), and without slowing the <10 s setup path for users who already granted permission (NFR-6).

### Story 4.1: Prime the microphone permission before the OS prompt

As a first-time user about to start a real recording,
I want a brief explanation before the microphone prompt,
So that I understand what it's for, that audio stays on my device, and that recording starts in seconds.

**Acceptance Criteria:**

**Given** the user taps the real **Start** and the microphone permission state is `prompt` and no priming sheet has been shown before
**When** Start is pressed
**Then** a one-time priming sheet appears **before** `getUserMedia`, presenting in order: *what* ("SnoreNoMore listens through your mic overnight"), *the privacy promise* ("Audio never leaves this device — nothing is uploaded"), and *the speed* ("You'll be recording in seconds")
**And** the sheet offers **Allow microphone** (triggers the real OS prompt) and **Not now — simulate instead** (routes to the Simulate path)

**Given** microphone permission is already granted
**When** the user taps Start
**Then** the priming sheet is skipped and recording begins directly, preserving the <10 s setup path (NFR-6)

**Given** the user is on the **Simulate** path
**When** they start a simulated night
**Then** the priming sheet never appears (real-path only)

**Given** the sheet gates the real Start
**When** it is shown
**Then** it reuses the existing info-sheet pattern and adds no egress (AD-2) and leaves the imperative audio refs untouched until Allow is pressed (AD-9)

_Traceability: Backlog **UX-2** (P3) · PRD **FR-7** · Architecture **AD-2, AD-9** · **NFR-6** · UX **UX-DR2**._

### Story 4.2: Keep an honest, actionable fallback when permission is denied

As a user who declined the microphone,
I want a clear next step instead of a dead-end alert,
So that I can still complete the loop via Simulate or learn how to enable the mic.

**Acceptance Criteria:**

**Given** the OS microphone prompt is denied (or permission state is already `denied`)
**When** the user attempts a real recording
**Then** an honest fallback **sheet** (not a bare `alert`) is shown with a primary **Simulate night** action and a **How to enable in Settings** hint

**Given** the fallback sheet
**When** the user chooses **Simulate night**
**Then** the full measure→quantify→correlate loop completes via the simulate path (FR-11), and the resulting night is marked simulated (consistent with Epic 2 / AD-11)

**Given** the denied fallback
**When** it renders
**Then** it reinforces the privacy framing and never sends audio or data off-device (AD-2)

_Traceability: Backlog **UX-2** (P3) · PRD **FR-7, FR-11** · Architecture **AD-2, AD-9, AD-11** · UX **UX-DR2**._

---

## Assumptions

Made autonomously (no user available), recorded here per the full-cycle run convention:

- **[ASSUMPTION E1]** Grouped the 8 items into **4 epics** by user-value theme **and** file-locality: BA-1/BA-2/UX-1 all touch `Trends` (+ one new stats helper), so they form one epic; BA-3/BA-4 both center on history honesty/correctness in `Results`(+`Detail`), so they pair; UX-3/UX-4 are interaction/inspection polish; UX-2 stands alone as onboarding.
- **[ASSUMPTION E2]** Placed **BA-4** in Epic 2 (Honest History), not the Trends epic, because its architecture attach point is `Detail`/`Results` (AD-11), not `Trends`. This diverges from the loose example grouping in the task prompt in favour of the Architecture *Backlog Landing* table.
- **[ASSUMPTION E3]** Story order within Epic 1 (BA-1 → BA-2 → UX-1) respects the EXPERIENCE.md note that UX-1's default "once BA-1 lands" consults the threshold; no story depends on a later story.
- **[ASSUMPTION E4]** `N_min = 2` per side is carried forward as the UX placeholder default (EXPERIENCE.md ASSUMPTION UX-A3), pending data-owner confirmation; it is expressed as a single constant so it can be tuned without restructuring the story.
- **[ASSUMPTION E5]** UX-2 is split into two stories (priming sheet + denied-state fallback) purely for single-dev-session sizing; both trace to the same backlog id.
- **[ASSUMPTION E6]** Output written to the canonical skill location `{planning_artifacts}/epics.md` rather than a dated subfolder, matching the epics-template convention. App code (`snorelab-local/`) and the spec folder (`_bmad-output/specs/`) were **not** modified.
