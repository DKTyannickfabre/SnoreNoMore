# Story 2.2: De-dupe and label multiple same-day nights

Status: done

## What was implemented

`Results` groups nights by month (existing behavior) and, within each month group,
further groups by calendar day via a new `dayKey(ts)` (derived from `night.start`,
per AD-4). Each `dayGroups` entry keeps its nights as **distinct list items**; when a
day has more than one night (`dg.items.length > 1`), a `"{day label} · {n} nights"`
sub-header is shown once, and each row's primary label switches from the day label to
a secondary **start–end time** (`fmtClock(n.start) – fmtClock(n.end)`) so same-day
rows are distinguishable.

## AC verification

- **Secondary start–end label + single day header**: verified live — simulating two
  nights on the same day produced a `"Tue, Sep 1 · 2 nights"` sub-header with two rows
  reading `"5:02 AM – 11:36 AM"` and `"3:54 AM – 11:35 AM"` respectively (each still
  showing its own score, timeline, and Simulated badge).
- **Trends counts same-day nights as distinct**: `Trends`/`remedyComparison` iterate
  `nights` directly (no day-merging step anywhere in the pipeline), so same-day nights
  are never collapsed into one point; only the Results *display* groups them under one
  visual day header. Confirmed by inspecting `remedyComparison`/`sideStats` — they
  operate on the full night list with no dedup step.
- **Day derived from `night.start`, read-only projection (AD-4/AD-7/AD-8)**: `dayKey`
  reads only `night.start`; grouping happens inside the `Results` render function with
  no writes to storage and no new persisted field.

## Assumptions / caveats

None — confirmed via live browser interaction (two same-day simulated nights).
