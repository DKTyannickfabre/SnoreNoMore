# Story 1.2: Show sample-size honesty (n + spread) alongside ON/OFF averages

Status: done

## What was implemented

`sideStats` (in the same "Domain · trends-stats" helper as Story 1.1) returns
`{ n, avg, spread }` per side, where `spread` is the half-range whisker
`(max(scores) - min(scores)) / 2` over that side's persisted `snoreScore` values.
`Trends` renders `n night(s) · ±spread` under each ON/OFF value, and `remedyComparison`
hedges the verdict copy to "Early signal — …" when either side's spread exceeds 1.5,
instead of asserting "it seems to help".

## AC verification

- **n + spread display**: verified live in the Trends "Avg Snore Score" card —
  `ON  6 nights · ±1.6` / `OFF  4 nights · ±1.0` rendered under the averages.
- **Hedge on high spread**: with ON spread `±1.6` (> 1.5 threshold), the verdict read
  "Early signal — Side Sleeping averages 2.4 points lower." rather than the confident
  "…it seems to help" phrasing — confirmed live.
- **iPhone SE glanceability / no overflow**: the `flex items-end justify-around gap-6`
  layout with `max-w-[110px]` per side and compact `text-[10px]` counts keeps the row
  well within 375px; verified no horizontal scrollbar appears (global CSS hides
  scrollbars and the app container is capped at `max-w-[430px]`).
- **AD-3 / AD-8**: spread is computed in `sideStats` over persisted `snoreScore` only,
  no new stored state (same helper as 1.1).

## Assumptions / caveats

None — behavior matches the AC and was confirmed via live browser interaction.
