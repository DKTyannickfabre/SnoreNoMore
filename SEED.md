# SEED — SnoreNoMore (snorelab-local)

> Input for `bmad-autonomous-loop`. The `OUTCOME` below is the frozen north star:
> once the loop starts, it is pinned verbatim and never edited. Everything else is
> mutable and exists only to serve it. To change direction, edit this file and start
> a fresh round 1 against the same spec folder.

## OUTCOME

An adult user can complete a nightly closed-loop to reduce snoring:

1. **Start** a night recording in <10 seconds after tagging up to 3 remedies and 2 lifestyle factors.
2. **Stop** in the morning and immediately see that night's timeline segmented into Quiet / Light / Loud / Epic / Noise with spikes, a Snore Score 0-10, and Time Snoring + %.
3. **Compare** in a 7-day Trends view where the user can select any remedy (e.g. Side Sleeping) and visually compare average Snore Score with remedy ON vs OFF, demonstrating whether it helps.

## CONTEXT

For habitual adult snorers who sleep with a phone on the nightstand. Problem: people don't know how much they snore or what actually helps them.

Domain method judges need — SnoreLab's **Measure → Quantify → Correlate → Feedback**:

- **Measure:** phone mic records all night, classifies audio by intensity.
- **Quantify:**
  - Time in Bed = `end - start - delay`
  - Time Snoring = `sum(Light + Loud + Epic)`
  - Snore % = `Time Snoring / Time in Bed`
  - Snore Score 0-10 normalized from Time Snoring + loudness (`0-1` = minimal, `7-10` = heavy)
- **Correlate:** each night the user tags **Remedies** (Side Sleeping, Nasal Strip, CPAP, Mouthpiece, Mouth Tape, SnoreGym, etc.) and **Factors** (Alcohol, Exhaustion, Four Hour Fast, Ate Late, Blocked Nose, Weight, etc.).
- **Feedback:** Trends shows whether a remedy/factor correlates with a lower score, enabling behavior change.

This is **NOT** a medical diagnostic tool.

## CONSTRAINTS

- **Platform:** PWA, must run 100% local in mobile Safari on iPhone SE 2023 (375×667), Add to Home Screen standalone, no backend, no `npm install` required to run (static `index.html` + `manifest.json`).
- **Stack:** React (or Preact) single-page, Tailwind-style classes, lucide icons allowed, no external native plugins.
- **Privacy:** audio never leaves the device, no cloud upload, no PHI in logs/localStorage beyond session data.
- **Compliance:** UI must state "Not medical advice. For apnea risk see doctor." No diagnosis claims, no real-time anti-snore alarm that wakes the user.
- **Must include:**
  - fall-asleep delay picker (5/10/15/20/30m) that skips recording during the delay
  - optional Soundscape toggle
  - Remedy/Factor multi-select with search + long-press info + checkmarks + Confirm count
  - Results list grouped by month with mini-timeline + icons + circular score
  - Detail view with hourly graph + legend + Time in Bed / Time Snoring / BreathFlow upgrade placeholder

## NON-GOALS

- No sleep apnea diagnosis, no AHI calculation, no CPAP device control.
- No user accounts, login, cloud sync, or social sharing.
- No real-time snore intervention (no vibration, no loud sound to stop snoring).
- No app store build, no Trends beyond 7/30 days, no Discover/Settings full implementation.

## SCOPE

Greenfield in `/snorelab-local` — overwrite the existing pilot `index.html`. Single deliverable that judges can open at `http://localhost:8000` and complete the OUTCOME flow end-to-end.
