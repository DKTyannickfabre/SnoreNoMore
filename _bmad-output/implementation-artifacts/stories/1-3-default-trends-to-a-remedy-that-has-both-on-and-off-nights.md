# Story 1.3: Default Trends to a remedy that has both ON and OFF nights

Status: done

## What was implemented

`findDefaultRemedy(inWindow, nMin)` scans `REMEDIES` for candidates with ≥1 ON and ≥1
OFF night, picks the best via `betterDefaultCandidate` (priority: meets `N_MIN` on both
sides → largest combined night count → strongest ON/OFF effect), and falls back to the
most-tagged remedy if none qualifies. `Trends`'s `remedy` state is lazily initialized
from `findDefaultRemedy` over the initial 7-day window.

## AC verification

- **Qualifying remedy exists**: verified live — with 6 Side-Sleeping-ON / 4-OFF nights
  in the window (the largest combined count meeting `N_MIN` on both sides), Trends
  opened with **Side Sleeping** selected by default (chip highlighted, no extra
  control added).
- **No remedy has both sides**: `findDefaultRemedy` falls back to the most-tagged
  remedy and `meetsMin`/gating logic (Story 1.1) then shows the neutral line rather
  than a false comparison — verified by code path (same helper, same gating render)
  and directly for other remedies (e.g. CPAP, which has 0 ON nights, correctly showed
  the gating line when manually selected).
- **Pure derivation, no extra state (AD-8)**: the default is computed once via a lazy
  `useState` initializer over the `nights` prop; it is not persisted, and user
  selection (via `setRemedy`) after the fact is ordinary local UI state per AD-8.

## Assumptions / caveats

- The tie-break order implemented is *meets-N_MIN-first, then combined count, then
  effect size* — a synthesis of the epic's two "Given" clauses (largest-combined vs.
  N_MIN-preferred once BA-1 lands). This reading was already baked into the code by
  the prior session; verified it does not contradict either AC clause and produces the
  expected default in the live test above.
