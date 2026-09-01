# Deferred Work

## Deferred from: code review (2026-09-01)

- **Apple touch icon uses an SVG data URI, not PNG** — `snorelab-local/index.html`'s `<link rel="apple-touch-icon" href="data:image/svg+xml,...">` and `manifest.json`'s icon entry both use an inline SVG. Historically iOS Safari's `apple-touch-icon` documentation calls for PNG; SVG support there is a newer, version-dependent WebKit behavior. On the target device (iPhone SE 2023, "Add to Home Screen" per SPEC), the home-screen icon could render blank/default on an older WebKit build. Not part of any of the 9 backlog stories' scope (pre-existing app-shell asset, out of scope for this review's spec context), and it cannot be verified without a physical iOS device/older Safari build — deferring rather than guessing at a PNG conversion that could introduce new risk without verification.
