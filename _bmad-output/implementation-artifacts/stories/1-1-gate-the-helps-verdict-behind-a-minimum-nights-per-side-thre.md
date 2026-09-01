# Story 1.1: Gate the "helps" verdict behind a minimum nights-per-side threshold

Status: done

## What was implemented

`N_MIN = 2` constant, a `sideStats(nightsForSide)` helper (n, avg, spread) and a
`remedyComparison(inWindow, remedy, nMin)` helper beside `computeMetrics` in
`snorelab-local/index.html`. `Trends` calls `remedyComparison` and renders either the
honest verdict or a neutral gating line depending on `meetsMin`.

## AC verification

- **Below-threshold suppression**: `remedyComparison` only computes `verdict` when
  `meetsMin` (both `on.n >= N_MIN` and `off.n >= N_MIN`); otherwise `verdict` stays
  `null` and `Trends` renders `"Not enough nights yet — need at least {N_MIN} with and
  without {remedy}."` instead. Verified live: selecting **CPAP** (0 ON / 6 OFF nights)
  showed the gating line with no "helps/worse" claim, while ON/OFF bars still rendered
  (0.0 and 3.4).
- **At/above threshold**: verified live — **Side Sleeping** (6 ON / 4 OFF) rendered the
  full verdict text ("Early signal — Side Sleeping averages 2.4 points lower.").
- **AD-3 (aggregates persisted `snoreScore`, no recompute)**: `sideStats` reduces over
  `nightsForSide.map(x => x.snoreScore)` only; it never calls `computeMetrics`.
- **AD-8 (new helper beside `computeMetrics`, no new stored state)**: `sideStats` /
  `remedyComparison` / `betterDefaultCandidate` are pure functions in the
  "Domain · trends-stats" section; no new `localStorage` key or `App` state was added.

## Assumptions / caveats

None — behavior matches the AC exactly as written and was confirmed via live browser
interaction (Playwright-driven click simulation), not just static code reading.
