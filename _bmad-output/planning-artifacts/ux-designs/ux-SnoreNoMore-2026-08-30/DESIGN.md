---
title: SnoreNoMore — Visual Design Spine (DESIGN.md)
product: SnoreNoMore (snorelab-local)
status: final
created: 2026-08-30
updated: 2026-08-30
author: Sally (UX Designer, BMAD)
nature: retro-spec — documents the visual identity of the already-shipped build
sources:
  - ../../prds/prd-SnoreNoMore-2026-08-30/prd.md
  - ../../../specs/spec-snorenomore/SPEC.md
  - ../../../specs/spec-snorenomore/stack.md
  - ../../../../snorelab-local/index.html
colors:
  # Surfaces (dark, near-black slate)
  bg.base: "#020617"          # slate-950 — app background, theme-color, splash
  bg.surface: "#0f172a"       # slate-900 — cards, inputs, sheets (often /60–/70 opacity)
  bg.surfaceMuted: "#0b1120"  # slate-900/40 — disabled tiles
  bg.elevated: "#1e293b"      # slate-800 — chips, toggles-off, active-press states
  border.default: "#1e293b"   # slate-800 — hairline card/control borders
  border.strong: "#334155"    # slate-700 — sheet top border, secondary buttons
  # Text
  text.primary: "#f1f5f9"     # slate-100 — headings, key numbers
  text.secondary: "#94a3b8"   # slate-400 — body, labels
  text.muted: "#64748b"       # slate-500 — meta, captions
  text.faint: "#475569"       # slate-600 — hints, empty-state, null bars
  # Brand / interactive
  accent.primary: "#0ea5e9"   # sky-500 — primary CTA, active tab, selection fill
  accent.primaryPress: "#0284c7" # sky-600 — CTA pressed
  accent.bright: "#38bdf8"    # sky-400 — active icons, spike line, brand mark
  accent.tintText: "#bae6fd"  # sky-200/100 — text on tinted selection chips
  accent.tintBg: "rgba(14,165,233,0.15)" # sky-500/15 — selected tag/chip fill
  # Action semantics
  action.stop: "#f43f5e"      # rose-500 — Stop & see results
  action.stopPress: "#e11d48" # rose-600
  action.simulate: "#10b981"  # emerald-500 — Simulate night (also demo/safe path)
  # Snore intensity levels (timeline / legend / live pill) — authoritative
  level.Quiet: "#10b981"      # emerald — not counted as snoring
  level.Light: "#eab308"      # yellow  — counts as snoring
  level.Loud: "#f97316"       # orange  — counts as snoring
  level.Epic: "#ef4444"       # red     — counts as snoring
  level.Noise: "#64748b"      # slate   — external sound, not counted
  # Snore Score gauge thresholds (0–10) — authoritative
  score.minimal: "#10b981"    # score < 2
  score.mild: "#eab308"       # 2 ≤ score < 5
  score.moderate: "#f97316"   # 5 ≤ score < 7
  score.heavy: "#ef4444"      # score ≥ 7
typography:
  family.sans: "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif"
  numeric: "tabular-nums / tabular figures for timers, scores, counts"
  scale.h1: "20px / bold / tracking-tight — screen title"
  scale.h2: "14px / semibold — section heading (slate-300)"
  scale.h3: "14px / semibold — card heading"
  scale.body: "14px / normal — item labels, verdict"
  scale.meta: "12px — counts, tags, sub-labels"
  scale.caption: "11px — helper text, disclaimer"
  scale.micro: "9–10px / uppercase tracking-wide — stat labels, axis ticks"
  scale.gaugeNumber: "size×0.30 (≈42px at 140) / bold — score in gauge"
rounded:
  sm: "4px — timeline segments, tiny bars"
  md: "6px — timeline container"
  lg: "8px — delay tiles, small buttons"
  xl: "12px — tag tiles, inputs, stat cards"
  2xl: "16px — result rows, primary/secondary CTAs, content cards"
  3xl: "24px — info bottom-sheet top corners"
  full: "9999px — pills, chips, toggles, gauge, nav mark, FAB-like score ring"
spacing:
  page.x: "16px (px-4) — global horizontal gutter"
  page.maxWidth: "430px — centered column; design target 375px (iPhone SE 2023)"
  grid.gap: "8px (gap-2) — tag/delay grids"
  section.gap: "20px (mb-5) — between setup sections"
  safeBottomNav: "64px (bottom-16 / pb-24) — clearance above fixed tab bar"
  tap.min: "44px effective — tiles, tabs, CTAs sized for thumb"
components:
  gauge: "SVG ring, -90° start, rounded cap, track slate-800, arc = score color, center = score.toFixed(1) + '/ 10'"
  miniGauge: "32px gauge variant for result rows"
  timelineBar: "flex row, per-segment flex-grow = duration, bg = level color; optional spike polyline above"
  spikes: "sky-400 polyline of per-segment peak, drawn above the timeline"
  legend: "5 swatches (Quiet/Light/Loud/Epic/Noise) with 10–11px labels"
  tagTile: "2-col grid button, icon + name + (check when selected | tappable (i) when not), sky border+tint when selected"
  delayPicker: "5-up grid of pill-tiles (5/10/15/20/30m), sky tint on active"
  soundscapeToggle: "full-width row with icon + label + iOS-style pill switch"
  infoSheet: "bottom sheet, grabber, icon+title+description, 'Got it' dismiss"
  stickyActionBar: "fixed above nav, gradient scrim, primary Start + secondary Simulate/Results"
  navBar: "fixed bottom, 3 tabs (Record/Results/Trends), active = sky-400"
  liveRing: "pulsing concentric rings tinted by current level, central timer"
  onOffBars: "two vertical bars ON(emerald)/OFF(red) with value, count, verdict line"
  disclaimer: "shield icon + 11px slate-500 text, present on Setup/Detail/Trends"
---

# SnoreNoMore — Visual Design Spine

> This DESIGN.md documents *how it looks*. Behavior, states, IA, and flows live in the peer
> [EXPERIENCE.md](EXPERIENCE.md). Both spines win on conflict with any mock or import. Tokens above
> are extracted from the shipped `snorelab-local/index.html` and are cross-referenced from
> EXPERIENCE.md by name using `{path.to.token}` syntax.

## Brand & Style

SnoreNoMore is a **calm, nocturnal, privacy-forward instrument** — a bedside measuring device, not a
clinical dashboard. The mood is *near-black, quiet, and legible in a dark room*: a single cool **sky**
accent for anything the user acts on, a disciplined **traffic-light intensity spectrum** (emerald →
yellow → orange → red) reserved exclusively for snore data, and generous negative space so the one
number that matters — the **Snore Score** — dominates the morning read.

Voice-in-pixels: reassuring, understated, honest. Nothing shouts. The loudest colored object on any
screen is the user's own data (the score gauge or the ON/OFF bars), never chrome. The design must
telegraph "this stays on your phone" through restraint, not badges.

Design tenets:
- **One accent, one job.** Sky (`{colors.accent.primary}`) means "interactive / selected." Never
  decorative.
- **Color is data.** The emerald→red spectrum is meaning-bearing (intensity/score), so it is never
  spent on decoration or state chrome.
- **Dark-room first.** Everything is legible at low brightness on `{colors.bg.base}` without glare.
- **Thumb-reachable.** Primary actions sit in the bottom third; the top is for reading, not tapping.

## Colors

Palette is a **slate 950→700 dark ramp** for surfaces + a **single sky accent** + **semantic data
colors**.

| Role | Token | Hex |
|------|-------|-----|
| App background | `{colors.bg.base}` | #020617 |
| Card / input surface | `{colors.bg.surface}` | #0f172a (freq. at 60–70% opacity) |
| Elevated chip / press | `{colors.bg.elevated}` | #1e293b |
| Hairline border | `{colors.border.default}` | #1e293b |
| Strong border (sheets) | `{colors.border.strong}` | #334155 |
| Primary text | `{colors.text.primary}` | #f1f5f9 |
| Secondary text | `{colors.text.secondary}` | #94a3b8 |
| Muted / meta | `{colors.text.muted}` | #64748b |
| Faint / hint / null | `{colors.text.faint}` | #475569 |
| Primary action / selection | `{colors.accent.primary}` | #0ea5e9 |
| Active icon / spike line / mark | `{colors.accent.bright}` | #38bdf8 |
| Selection tint fill | `{colors.accent.tintBg}` | sky-500 @ 15% |
| Stop recording | `{colors.action.stop}` | #f43f5e |
| Simulate / safe demo | `{colors.action.simulate}` | #10b981 |

**Data spectrum (authoritative — do not restyle):**

| Level | Token | Hex | Counts as snoring? |
|-------|-------|-----|--------------------|
| Quiet | `{colors.level.Quiet}` | #10b981 | No |
| Light | `{colors.level.Light}` | #eab308 | Yes |
| Loud | `{colors.level.Loud}` | #f97316 | Yes |
| Epic | `{colors.level.Epic}` | #ef4444 | Yes |
| Noise | `{colors.level.Noise}` | #64748b | No (external sound) |

**Snore Score gauge** uses the same spectrum, thresholded: `{colors.score.minimal}` (<2),
`{colors.score.mild}` (2–5), `{colors.score.moderate}` (5–7), `{colors.score.heavy}` (≥7). The
numeral, the ring arc, and the qualitative word ("Minimal…Heavy") always share one color so the read
is instant.

Contrast note: emerald/yellow on `{colors.bg.base}` clears ~AA for the large numerals and swatches at
the sizes used; the yellow **Light** token is the weakest for small text — see EXPERIENCE.md
Accessibility Floor for the "never encode meaning in a small yellow glyph alone" rule.

## Typography

System sans (`{typography.family.sans}`) throughout — zero web-font cost, native on iOS. Hierarchy is
carried by **weight and size**, not family:

- **Screen titles** — `{typography.scale.h1}` (e.g. "Tonight's setup", "Trends").
- **Section / card headings** — `{typography.scale.h2}` / `{typography.scale.h3}`, slate-300.
- **The Score** — `{typography.scale.gaugeNumber}`, colored by threshold; the single largest glyph on
  the morning screen.
- **Timers & counts** — `{typography.numeric}` so digits don't jitter as the live timer ticks.
- **Meta / helper / disclaimer** — 9–12px, slate-500/600, uppercase tracking-wide for stat labels.

## Layout & Spacing

- **Fixed mobile column.** Content is centered at `{spacing.page.maxWidth}`; the true design target is
  **375×667** (iPhone SE 2023), standalone PWA. Horizontal gutter is `{spacing.page.x}`.
- **Three-zone vertical rhythm.** Read zone (scrolling content) → sticky **action scrim** (Setup only)
  → fixed **tab bar**. Content reserves `{spacing.safeBottomNav}` bottom clearance so nothing hides
  behind the nav.
- **Grids.** Delay is a 5-up pill grid; tags are a 2-up tile grid; night stats are a 3-up card grid —
  all at `{spacing.grid.gap}`.
- **Sections** separated by `{spacing.section.gap}`.

## Elevation & Depth

Depth is expressed by **surface tint + hairline border**, not heavy shadows:
- Base plane = `{colors.bg.base}`; cards lift via `{colors.bg.surface}` + `{colors.border.default}`.
- Only two elements carry real shadow: the **primary Start CTA** (soft sky glow) and the **Stop CTA**
  (soft rose glow) — the two moments that matter most.
- **Modals/sheets** are the top layer: a `black/60` scrim + a slate-900 sheet with
  `{colors.border.strong}` top edge and a grabber. The **Detail view** is a full-screen slate-950
  overlay (z-40) above the tabbed shell; the **Info sheet** (z-50) sits above everything.

## Shapes

Rounded, soft, bedside-friendly. Corner ramp: `{rounded.sm}` (data segments) → `{rounded.xl}` (tiles,
inputs, cards) → `{rounded.2xl}` (rows & CTAs) → `{rounded.3xl}` (info sheet) → `{rounded.full}`
(pills, chips, toggles, the score ring, the live recording ring). Circles carry all quantitative
summaries (Gauge, MiniScore, live ring); bars carry all temporal data (timeline, hourly, ON/OFF,
nightly).

## Components

Visual specs (behavior in EXPERIENCE.md · Component Patterns):

- **Gauge / MiniScore** — SVG ring rotated −90°, `{colors.bg.elevated}` track, arc stroke = score
  color with round cap; center shows `score.toFixed(1)` over `/ 10`. Full size 128–140px (Detail),
  32px (result rows).
- **TimelineBar + Spikes** — horizontal flex of level-colored segments (grow = duration) in a
  `{rounded.md}` clip; optional `{colors.accent.bright}` peak polyline floats above (Detail only).
- **Legend** — five `{colors.level.*}` swatches with labels; always paired with a timeline.
- **TagTile** — `{rounded.xl}` button, leading lucide icon, name, and a trailing **check badge**
  (sky, when selected) or **tappable (i) icon** (when not). Selected = sky border + `{colors.accent.tintBg}`;
  disabled (cap reached) = muted slate, no border emphasis.
- **DelayPicker** — 5 pill-tiles; active = sky border + tint.
- **SoundscapeToggle** — row with rounded-lg icon chip + iOS-style pill switch (sky when on).
- **InfoSheet** — bottom sheet with grabber, icon chip, title, description, full-width "Got it".
- **StickyActionBar** — gradient scrim; primary **Confirm & Start Night** (sky, glow, live "· N rem, M
  fac" count) + secondary **Simulate night** (emerald icon) and optional **Results** button.
- **LiveRing** — two pulsing concentric rings tinted by current level over a bordered core showing the
  moon/clock icon, `{typography.numeric}` timer, and phase label.
- **HourlyGraph** — stacked snore-only bars (`{colors.level.Light/Loud/Epic}`) with start/end clock
  ticks.
- **ON/OFF bars** — two bars, ON = `{colors.action.simulate}`, OFF = `{colors.action.stop}`; value +
  night count under each; null side renders a 2px `{colors.text.faint}` stub. Verdict line below in
  emerald (helps) / amber (worse) / slate (no clear difference).
- **NavBar** — 3 fixed tabs; active icon+label = `{colors.accent.bright}`.
- **Disclaimer** — shield glyph + 11px slate-500 line; mandatory on Setup, Detail, Trends.

## Do's and Don'ts

**Do**
- Reserve sky strictly for "you can act on this / this is selected."
- Keep the emerald→red spectrum meaning-locked to intensity and score.
- Let the Score gauge be the single dominant object on the morning screen.
- Keep the disclaimer quiet but ever-present on Setup, Detail, and Trends.
- Pair every color-coded datum with a label or shape (legend, ON/OFF text) — never color alone.

**Don't**
- Don't add a second brand accent or gradient wash that competes with data color.
- Don't recolor a level or score threshold — those hues are authoritative contracts.
- Don't use red/rose for anything except **Stop** and **Epic/heavy** data (avoid false alarm tone).
- Don't introduce heavy drop-shadows; depth is tint + hairline, with glow only on Start/Stop.
- Don't render dense body text on `{colors.level.Light}` yellow — it fails small-text contrast.
