# Zrain Tools Windows path repair (2026-11-05)

This replaces only the unsafe file-path conversion in `tests/approved-ux.test.mjs` that generated `C:\C:\Users...` paths on Windows.

- Change: use `fileURLToPath(new URL('../', import.meta.url))` from `node:url` instead of `.pathname`.
- No application functionality, Cloudflare names, UI content or Community IDs changed.
- `npm run check`: 65/65 passing on Node.js 22 (Linux). The first report of 60/65 on Windows was caused by this path bug.
- Actual Windows deployment still requires verification using the authenticated user's machine and valid Cloudflare/Firebase configurations.
- The existing `Deploy-Zrain-47-Tools.ps1` syncs the pinned official Zrain UI before its release preflight, so manual `node scripts/release-preflight.mjs` run before that sync may fail legitimately.
- This release does NOT automatically overwrite `Zrain\Projects\zrain-tools`; it runs out of `Downloads\Zrain-47-Tools-Release` and targets the 5 existing Cloudflare Pages sites only after local checks pass. Preserve your existing `zrain-tools` source until the release is verified.
