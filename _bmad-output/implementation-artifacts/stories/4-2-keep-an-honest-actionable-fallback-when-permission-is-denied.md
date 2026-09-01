# Story 4.2: Keep an honest, actionable fallback when permission is denied

Status: done

## What was implemented

`MicDeniedSheet` (bottom sheet, not `alert`) is shown whenever `beginRealCapture`'s
`getUserMedia` call throws (real-time denial) or `startReal` finds permission state
already `denied`. It offers a primary **Simulate night** action (routes to `doSimulate`
with the same tagged config) and a **"How to enable: Settings → Safari/SnoreNoMore →
Microphone → Allow."** hint, plus privacy-reinforcing copy ("No audio ever leaves your
device…").

## AC verification

- **Denied → sheet, not alert**: verified live by mocking `getUserMedia` to reject with
  a `NotAllowedError` after tapping "Allow microphone" on the prime sheet — the
  `MicDeniedSheet` rendered with "Microphone unavailable", the privacy-reinforcing
  line, a **Simulate night** button, and the Settings hint. No `window.alert` is used
  anywhere in the denied path (confirmed from source: `setMicSheet({type:'denied', ...})`
  only).
- **Simulate night completes the loop, marked simulated**: verified live — tapping
  **Simulate night** in the denied sheet produced a completed night detail view with
  the **Simulated** badge and demo note (Story 2.1), confirming the full
  measure→quantify→correlate loop via the simulate path and correct `simulated: true`
  tagging (AD-11).
- **Reinforces privacy, no egress (AD-2)**: the sheet's copy explicitly states "No
  audio ever leaves your device…"; `doSimulate` (its only action) never touches
  `getUserMedia`/network, consistent with AD-2.

## Assumptions / caveats

- As with Story 4.1, the real OS "denied" permission state itself cannot be triggered
  in this environment; the fallback-sheet logic was verified end-to-end by mocking
  `getUserMedia` to reject and driving the actual rendered UI through real click
  events, confirming the sheet (not an alert) appears and its Simulate action
  completes the loop correctly.
