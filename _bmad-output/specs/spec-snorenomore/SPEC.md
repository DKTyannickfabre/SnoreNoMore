---
id: SPEC-snorenomore
companions: [stack.md]
sources: [../../../SEED.md]
---

> **Canonical contract.** This SPEC and the files in `companions:` are the complete, preservation-validated contract for what to build, test, and validate. Source documents listed in frontmatter are for traceability — consult them only if you need narrative rationale or prose color this contract intentionally omits.

# SnoreNoMore

## Why

A pain to solve: habitual adult snorers who sleep with a phone on the nightstand don't know how much they snore or what actually helps them. SnoreNoMore closes the loop — measure snoring overnight, quantify it into a comparable score, correlate it with the remedies and lifestyle factors the user tagged, and feed that back as a plain ON-vs-OFF comparison — so the user can change behavior on evidence rather than guesswork. It is explicitly not a medical diagnostic tool.

## Capabilities

- **CAP-1** — Nightly setup & tagging
  - **intent:** User tags up to 3 remedies and 2 lifestyle factors via a searchable multi-select (long-press info, checkmarks, Confirm count), picks a fall-asleep delay, optionally enables a soundscape, and starts the night recording.
  - **success:** Recording starts in under 10 seconds from opening setup, with the delay, remedy and factor selections captured for the night.

- **CAP-2** — All-night capture & intensity classification
  - **intent:** The phone mic records through the night, skips the fall-asleep delay window, and classifies audio into Quiet / Light / Loud / Epic / Noise segments with loudness spikes.
  - **success:** A completed night yields a segmented intensity timeline with spikes, computed on-device with no audio leaving the device.

- **CAP-3** — Morning quantification & night detail
  - **intent:** On stop, compute Time in Bed (`end − start − delay`), Time Snoring (`Light + Loud + Epic`), Snore % and Snore Score 0–10, and present the segmented timeline, a circular score, and an hourly graph with legend.
  - **success:** Immediately on stop the user sees the Snore Score, Time Snoring + %, and the segmented timeline for that night.

- **CAP-4** — Results history
  - **intent:** Persist nights locally and list them grouped by month, each row showing a mini-timeline, remedy/factor icons and a circular score, and opening to the CAP-3 detail view.
  - **success:** Past nights appear grouped by month and each opens to its detail view.

- **CAP-5** — 7-day Trends correlation
  - **intent:** Aggregate the last 7 days and let the user select any tagged remedy to compare the average Snore Score with the remedy ON versus OFF.
  - **success:** Selecting a remedy shows ON-vs-OFF average scores, visibly demonstrating whether it helps.

- **CAP-6** — Compliance & privacy
  - **intent:** State "Not medical advice. For apnea risk see doctor.", keep all audio and data on-device, make no diagnosis claims, and raise no real-time anti-snore alarm.
  - **success:** The disclaimer is visible in the UI and no network or cloud call carries audio or night data.

## Constraints

- Platform: PWA running 100% local in mobile Safari on iPhone SE 2023 (375×667), Add to Home Screen standalone, no backend, runnable with no `npm install` — a static `index.html` + `manifest.json` served at `http://localhost:8000`.
- Stack: React or Preact single-page app, Tailwind-style utility classes, lucide icons allowed, no external native plugins. See `stack.md`.
- Privacy: audio never leaves the device, no cloud upload, no PHI in logs/localStorage beyond session data.
- Compliance: UI states "Not medical advice. For apnea risk see doctor."; no diagnosis claims; no real-time anti-snore alarm that wakes the user.
- Required UI elements: fall-asleep delay picker (5/10/15/20/30m) that skips recording during the delay; optional Soundscape toggle; Remedy/Factor multi-select with search + long-press info + checkmarks + Confirm count; Results list grouped by month with mini-timeline + icons + circular score; Detail view with hourly graph + legend + Time in Bed / Time Snoring / BreathFlow upgrade placeholder.
- Delivery: greenfield in `/snorelab-local`, overwriting the existing pilot `index.html`; a single deliverable that opens at `http://localhost:8000` and completes the OUTCOME flow end-to-end.

## Non-goals

- No sleep apnea diagnosis, no AHI calculation, no CPAP device control.
- No user accounts, login, cloud sync, or social sharing.
- No real-time snore intervention (no vibration, no loud sound to stop snoring).
- No app store build, no Trends beyond 7/30 days, no full Discover/Settings implementation.

## Success signal

- On a phone-sized viewport served at `http://localhost:8000`, an adult can tag remedies/factors and start recording in under 10 seconds, stop in the morning to immediately see a segmented Quiet/Light/Loud/Epic/Noise timeline with spikes plus a Snore Score 0–10 and Time Snoring + %, and open a 7-day Trends view that compares a selected remedy's average Snore Score ON vs OFF — the full Measure → Quantify → Correlate → Feedback loop, end-to-end.
