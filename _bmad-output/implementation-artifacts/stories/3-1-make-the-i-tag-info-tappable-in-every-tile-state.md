# Story 3.1: Make the (i) tag info tappable in every tile state

Status: done

## What was implemented

`TagItem` always renders a dedicated info `<button>` (info icon) as a trailing element
inside the tile, independent of `selected` state — it is never replaced by the
checkmark (the checkmark is an additional leading/trailing badge, not a replacement).
The info button has `aria-label={'About ' + item.name}`, a `p-[13px] -m-[13px]`
padded hit area (13px padding × 2 + 18px icon = 44px, meeting the ≥44px target), and
its `onClick` calls `e.stopPropagation()` before invoking `onLongInfo`, so it never
toggles the tile's selection. The pre-existing 450ms long-press timer (`onPointerDown`
→ `setTimeout`) remains as a redundant shortcut.

## AC verification

- **(i) present & tappable in every state, including selected**: verified live — after
  selecting **Side Sleeping** (tile turned selected/checked), tapping the (i) button
  still opened the info modal for "Side Sleeping" **and** the tile remained selected
  (`border-sky-500` class unchanged) — confirmed via direct DOM event dispatch driving
  the same Preact click handlers a real tap would.
- **44px target + aria-label**: confirmed from source (`p-[13px] -m-[13px]` around an
  18px icon = 44×44px hit area; `aria-label="About Side Sleeping"` verified in the
  accessibility snapshot).
- **Propagation stopped**: confirmed live (selection state unchanged after tapping (i)
  on a selected tile, see above).
- **Long-press remains a redundant shortcut**: the `onPointerDown`/`onPointerUp`
  450ms-timer path is untouched and still calls `onLongInfo`, it is just no longer the
  only path.

## Assumptions / caveats

- **Note (non-blocking, pre-existing from prior session, not a story regression):** the
  info `<button>` is nested inside the outer tile `<button>`, which is technically
  invalid HTML5 (interactive content inside interactive content). In practice this
  works correctly in the tested browser (Chromium) because `stopPropagation()` on the
  inner click prevents the outer handler from firing, and this is the same pattern the
  AC explicitly allows ("alongside/behind the check, or as a persistent leading
  affordance"). Left as-is since it functions correctly and a semantic-HTML rewrite
  (e.g. `role="button"` on a `div`) was outside this story's scope — flagged here for
  awareness rather than "fixed" so as not to touch working code beyond the story's
  intent.
