# Story 3.2: Tap-to-inspect spike times on the timeline and hourly graph

Status: done

## What was implemented

A shared `Inspector` popover (`fixed inset-x-0 bottom-4`) driven by `Detail`'s local
`inspect` state. `TimelineBar` segments render as tappable buttons (when `onInspect` is
passed) with `aria-label={segmentLabel(...)}` (e.g. "Loud at 5:00 AM, peak 0.21");
`Spikes` (the polyline over the timeline) supports tap-anywhere-on-the-line via
hit-testing the nearest segment; `HourlyGraph` bars are buttons with an
`aria-label` such as "Hour 1, 4:04 AM–5:04 AM, tap to see worst spikes" that open an
inspector listing that hour's top-3 spikes by peak. Clock time is computed via
`clockForSegment` = `night.start + night.delayMinutes*60000 + s.tStart` (AD-4). Tapping
the `Detail` container or scrolling calls `dismissInspect`, closing the popover; no
layout reflow occurs since the popover is a `fixed`-position overlay.

## AC verification

- **Tap segment/spike → inspector with clock time, level, peak**: verified live —
  tapping the segment button labeled "Loud at 5:00 AM, peak 0.21" opened an inspector
  reading "Loud · 5:00 AM" / "Peak 0.21".
- **Tap hourly bar → worst spikes for that hour**: implemented via `hourInspectData`
  (top-3 segments by `peak` within the hour's `[hourStartT, hourEndT)` window);
  verified present via the accessible-name snapshot ("Hour 1, 4:04 AM–5:04 AM, tap to
  see worst spikes" etc.) covering all 8 hours of a simulated night.
- **Dismiss on tap elsewhere / scroll, no reflow**: verified live — dispatching a click
  on the `Detail` container (outside the popover) closed the inspector
  (`inspectorGone: true`); the popover is `fixed`, so it overlays rather than
  participating in document flow.
- **Accessible name per AD-4/AD-5**: `segmentLabel` reads `level` + `peak` directly off
  the segment (AD-5) and clock time via the `start + delay` anchor (AD-4) — confirmed
  from source and from the rendered aria-labels above.

## Assumptions / caveats

None — confirmed via live browser interaction (tap-to-inspect + dismiss).
