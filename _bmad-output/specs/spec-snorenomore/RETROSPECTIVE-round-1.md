# Retrospective — SnoreNoMore, Loop Round 1 (headless, stories mode)

Spec: `_bmad-output/specs/spec-snorenomore` · Branch: `loop/snorenomore` · Tag: `loop-round-1`

## Verdict: accepted-with-open-items

All six stories (S1–S6) covering CAP-1..CAP-6 were implemented into the single static
deliverable `snorelab-local/index.html` + `manifest.json` and verified running end-to-end.

## Evidence (built vs. contract)

- **S1 shell/compliance:** Record/Results/Trends navigation present; disclaimer
  "Not medical advice. For apnea risk see doctor." visible on Setup, Detail, and Trends. ✔
- **S2 setup & tagging:** delay picker 5/10/15/20/30m, searchable remedy/factor multi-select
  with checkmarks, live Confirm count (max 3 remedies / 2 factors), long-press info, soundscape
  toggle; Start reachable in ~1–2s (<10s). ✔
- **S3 capture & classification:** `getUserMedia` + Web Audio RMS bucketing into
  Quiet/Light/Loud/Epic/Noise with spikes, delay-window suppression, plus a Simulate demo path. ✔
- **S4 quantification & detail:** formulas verified against persisted data for all nights —
  `timeSnoring = Σ(Light+Loud+Epic)`, `snorePct = timeSnoring/timeInBed`,
  `timeInBed = end−start−delay`, `snoreScore ∈ [0,10]`; circular score, segmented timeline,
  hourly graph + legend, Time in Bed / Time Snoring, BreathFlow placeholder. ✔
- **S5 results history:** nights persisted in localStorage, grouped by month, mini-timeline +
  icons + circular score, open to detail. ✔
- **S6 trends:** 7/30-day toggle; selecting a remedy shows ON-vs-OFF average Snore Score with an
  honest verdict and correct empty-state gating when a side has no nights. ✔

## Privacy/compliance check

No `fetch`/`XHR`/`sendBeacon`/`WebSocket`/upload of audio or night data found in source; audio
stays on-device; disclaimer present. ✔

## Open items (non-blocking backlog)

- UX-1 Trends should default to a remedy with both ON and OFF nights.
- UX-2 Mic permission priming to reinforce on-device + <10s feel.
- UX-3 Make the (i) tag icon tappable, not long-press only (a11y parity).
- UX-4 Tap-to-inspect spike times on timeline/hourly bars.
- BA-1 Minimum nights-per-side threshold before a "helps" claim.
- BA-2 Show sample-size honesty (spread/confidence) with ON/OFF averages.
- BA-3 De-dupe/label multiple same-day nights.
- BA-4 Clarify demo vs real measured variance in synthetic data.
