# Story 2.1: Mark simulated nights with an explicit "Simulated" badge and note

Status: done

## What was implemented

A `SimulatedBadge` component (flask icon + "Simulated" pill, emerald-tinted) rendered
in both `Detail` (header) and `Results` (row) whenever `night.simulated` is truthy,
replacing the prior `· sim` marker. `Detail` also shows a one-line note "Demo data —
synthesized to show the full flow, not a real measurement." directly under the header
when simulated.

## AC verification

- **Badge on Detail + Results**: verified live — every simulated night created during
  testing showed the "Simulated" badge in both the Detail header and its Results row.
- **Detail demo note**: verified live — "Demo data — synthesized to show the full flow,
  not a real measurement." rendered directly below the header on simulated nights.
- **Real nights show nothing**: `night.simulated && html\`...\`` short-circuits to
  nothing for falsy/absent `simulated`; the real-capture path (`stopReal`) explicitly
  sets `simulated: false`, so real nights never render the badge or note.
- **Back-compat / no crash on pre-`simulated` records (AD-11)**: the guard is
  `night.simulated` truthiness, not a strict `=== true` check with a required field, so
  legacy records without the key are treated as not-simulated with no schema migration
  and no crash.

## Assumptions / caveats

None — confirmed via live browser interaction across multiple simulated nights.
