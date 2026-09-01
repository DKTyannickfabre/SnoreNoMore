# Story 4.1: Prime the microphone permission before the OS prompt

Status: done

## What was implemented

`startReal(config)` queries `navigator.permissions.query({name:'microphone'})` (falling
back to `'prompt'` if the Permissions API is unsupported, e.g. Safari). If `denied`, it
routes straight to the denied sheet (Story 4.2). If not `granted` and the
`snorenomore.micPrimed` localStorage flag is unset, it sets the flag and shows
`MicPrimeSheet` instead of calling `getUserMedia`; only after "Allow microphone" is
tapped does `beginRealCapture` (which calls `getUserMedia`) run. If already `granted`,
or already primed once, it calls `beginRealCapture` directly. `MicPrimeSheet` never
appears on the Simulate path (`doSimulate` has no permission/mic-sheet logic at all).

## AC verification

- **Prompt state + not yet primed → sheet before `getUserMedia`**: verified live by
  mocking `navigator.permissions.query` to return `{state:'prompt'}` and clearing the
  primed flag, then tapping "Confirm & Start Night" — the `MicPrimeSheet` appeared
  with the exact required copy order: "SnoreNoMore listens through your mic overnight."
  → "Audio never leaves this device — nothing is uploaded." → "You'll be recording in
  seconds.", with **Allow microphone** and **Not now — simulate instead** buttons.
- **Already granted → skip sheet, keep <10s path (NFR-6)**: verified live by mocking
  permission state to `'granted'` — tapping Start went straight past the prime sheet
  (confirmed via `innerText`, avoiding a false-positive from the source `<script>`
  text) directly to the mic-acquisition step.
- **Simulate path never shows the sheet**: confirmed from source — `doSimulate` has no
  reference to `micSheet`/`MicPrimeSheet` at all; only `startReal` (real Start) does.
- **Reuses info-sheet pattern, no egress, refs untouched until Allow (AD-2/AD-9)**:
  `MicPrimeSheet` is a bottom-sheet matching `InfoModal`'s visual pattern; no network
  call is made by the sheet itself; `audioRef`/`recRef` are only touched inside
  `beginRealCapture`, which is not invoked until "Allow microphone" is pressed.

## Assumptions / caveats

- Real hardware `getUserMedia`/OS permission-prompt behavior cannot be triggered in
  this environment; the priming-gate *logic* (permission-state branching, one-time
  flag, sheet content, and the skip-when-granted fast path) was verified end-to-end by
  mocking `navigator.permissions.query` and `navigator.mediaDevices.getUserMedia` at
  the JS level and driving real click events through the actual rendered UI — this
  exercises the same code paths a real device would, short of the native OS dialog
  itself.
