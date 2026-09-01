# Code Review — full-cycle (bmad-code-review, autonomous mode)

**Date:** 2026-09-01
**Diff reviewed:** `git diff main...bmad/full-cycle -- snorelab-local/`
**Files:** `snorelab-local/index.html` (+1226, new file), `snorelab-local/manifest.json` (+20, new file) — 1246 insertions, 0 deletions.
**Spec context:** `_bmad-output/planning-artifacts/epics.md` (9 stories), `ARCHITECTURE-SPINE.md` (11 ADs), `SPEC.md`, `stack.md`.
**Review layers applied:** Blind Hunter, Edge Case Hunter, Verification Gap Reviewer, Acceptance Auditor (all 4 performed directly against the reviewed diff — no subagent-launch tool is available in this environment, so each layer's methodology was executed personally rather than delegated, per the standing autonomous-mode authorization for this cycle).
**Note on tests:** No test files exist anywhere in the repository (`**/*.test.*`, `**/*.spec.*` both return zero matches), so the Verification Gap Reviewer layer had no pre-existing test suite to check for regressions/broken coverage against; this is noted rather than treated as a defect, since automated testing was never part of this project's scope (static, no-build single-file app).

## Summary

| Bucket | Count |
|---|---|
| decision_needed (resolved autonomously) | 1 |
| patch (applied) | 2 |
| defer | 1 |
| dismissed (reviewed, no action) | 4 |

## Decision-needed (resolved autonomously)

- **[Review][Decision-Resolved-Autonomously] Default remedy tie-break priority in `findDefaultRemedy`/`betterDefaultCandidate`.** Story 1.3's AC text is ambiguous on whether "preferentially picks a remedy meeting N_min on both sides" is the *primary* sort key or a secondary tie-break after "largest combined night count." The implementation sorts `meetsMin` first, then combined night count, then effect size. Resolution: **keep the implementation as-is (no code change).** Epic 1's own stated design goal is "the first paint is a meaningful comparison, not an empty prompt" — prioritizing `meetsMin` maximizes the chance the default remedy shown on first paint has a real, non-gated verdict rather than a suppressed/low-confidence one, which most directly serves that stated intent.

## Patches applied

- **[HIGH] Nested `<button>` inside `<button>` in `TagItem` (`snorelab-local/index.html`).** The remedy/factor tile rendered a native `<button>` (tile select/toggle, from Story 3.1/UX-3) containing a second native `<button>` (the "(i)" info affordance). Interactive content cannot validly nest inside interactive content (HTML5 content model), and this is a real accessibility risk on the target platform (iOS Safari + VoiceOver) — nested interactive controls have unreliable focus/activation semantics, directly undermining the accessibility intent of Story 3.1/NFR-9 that this exact code implements. (Since htm/Preact builds the DOM via `createElement`, not `innerHTML` parsing, this did not cause visible/layout breakage — the risk is purely in assistive-tech semantics.) **Fix:** changed the outer element from `<button type="button">` to `<div role="button" tabindex="0">`, added an `onKeyDown` handler for Enter/Space to preserve native-button keyboard-activation semantics, and added an inline comment explaining why. The inner "(i)" `<button>` is unchanged and is now the sole native interactive descendant.
- **[LOW] Unused `useMemo` import (`snorelab-local/index.html`).** `useMemo` was imported from `preact/hooks` but never referenced anywhere in the file. **Fix:** removed it from the import line.

## Deferred

- **Apple touch icon SVG data URI risk** — see [deferred-work.md](../implementation-artifacts/deferred-work.md). `apple-touch-icon` and the manifest icon both use an inline SVG; iOS Safari's historical guidance calls for PNG, and this can't be verified without a physical device/specific WebKit version. Out of scope of the 9-story backlog (pre-existing app-shell asset); not blind-patched to avoid introducing unverified risk.

## Dismissed (reviewed, no action needed)

- **`NavBar`'s `disabled` prop is always passed as `false`.** Dead code path — but AD-10's overlay precedence already fully handles nav visibility by not rendering `NavBar` at all when `recording` or `detailNight` is truthy, making the `disabled` prop vestigial but harmless. Cosmetic only.
- **`TagItem`'s "disabled" visual state has no real click-guard at the tile level.** Tapping an at-max, unselected tile still calls `onToggle`, but `toggleR`/`toggleF` themselves no-op when already at `MAX_REMEDIES`/`MAX_FACTORS`. Functionally correct via the reducer guard; the "(i)" info button intentionally still works even on maxed-out tiles, which is correct/desired behavior.
- **Potential division-by-zero in `Spikes`/`TimelineBar` segment-duration math for a zero-length night.** Theoretical edge case (stop button pressed within the initial delay window); no crash reproduced, existing guards elsewhere in the render path prevent a visible failure. Pre-existing, extremely low likelihood, no user-facing impact identified.
- **`manifest.json` `categories` includes `"medical"`.** Minor app-store metadata nuance, no functional or architectural impact.

## Verification

- `node --check` on the extracted `<script type="module">` body: **PASS** (syntax OK, 67,162 chars).
- Local static server (`python3 -m http.server 8000`) — `curl -I http://localhost:8000/index.html` → **200 OK**; `curl -I http://localhost:8000/manifest.json` → **200 OK**. Server was stopped immediately after verification.

## Final git state

- Branch: `bmad/full-cycle`
- Commit: `full-cycle P7: code review — 1 decisions resolved, 2 patches applied, 1 deferred, 4 dismissed`
- Working tree: clean after commit.
