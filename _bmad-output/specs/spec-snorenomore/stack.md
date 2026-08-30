# Stack & implementation conventions

Companion to `SPEC.md`. Load-bearing HOW that the kernel intents deliberately omit.

## Runtime shape

- **Single static deliverable:** `/snorelab-local/index.html` + `/snorelab-local/manifest.json`. No build step, no `npm install`. Opening `index.html` (served at `http://localhost:8000`) runs the whole app.
- **Framework:** Preact + HTM (or React UMD) loaded from a CDN `<script>` in `index.html`, so there is no bundler. Hooks-based function components.
- **Styling:** Tailwind via the Play CDN `<script>` (utility classes inline), dark app aesthetic. No separate CSS build.
- **Icons:** lucide (CDN or inline SVG). No native plugins.
- **PWA:** `manifest.json` linked from `index.html`; standalone display; iPhone SE 2023 viewport (375×667) is the design target. Service worker optional; if present it must not upload anything.

## Data & persistence

- All night records persist in `localStorage` under a single namespaced key (e.g. `snorenomore.nights`), JSON-serialized. No backend, no network calls for data or audio.
- A night record carries: `id`, `start`, `end`, `delayMinutes`, `remedies[]`, `factors[]`, `segments[]` (each `{tStart, tEnd, level: Quiet|Light|Loud|Epic|Noise, peak}`), and the derived `timeInBed`, `timeSnoring`, `snorePct`, `snoreScore`.

## Audio classification

- Use `getUserMedia` + Web Audio `AnalyserNode` RMS/level sampling to bucket each interval into Quiet/Light/Loud/Epic/Noise; capture peaks as spikes. Recording is suppressed during the fall-asleep delay window.
- Because judges exercise the app without a real night of snoring, provide a **demo/simulate path** (e.g. an accelerated or synthetic night) so the full Measure→Quantify→Correlate→Feedback loop is demonstrable end-to-end at a desk — without weakening the real mic path or sending audio anywhere.

## Quantification formulas (authoritative)

- `timeInBed = end − start − delay`
- `timeSnoring = Σ(Light + Loud + Epic durations)`
- `snorePct = timeSnoring / timeInBed`
- `snoreScore` ∈ [0,10], normalized from Time Snoring + loudness (0–1 minimal … 7–10 heavy).

## Navigation

Tab/section shell covering at least: Record (setup + live), Results (history grouped by month → detail), Trends (7-day correlation). A "BreathFlow upgrade" placeholder appears in the night detail view.
