## Release v2.4.0

This workspace is the 46-tool targeted-fix source release. Read `RELEASE-v2.4.0.md` for scoped modifications, deployment and limits. No live Cloudflare or Ecosystem changes are made by building this package.

# Historical Zrain Tools v2.3.0 status (2026-11-05)

| Check | Status |
| --- | --- |
| 46 tools in 5 family sites; Aâ€“Z within family | Built |
| Image Cropper and watermark mouse/touch + numeric sync | Code implemented; needs device tests |
| Image compressor only offers smaller result | Code implemented; real-image QA pending |
| AI background remover (Apache-2.0 UÂ²-Netp) | Experimental, model/runtime load not verified |
| PDF organizer thumbnails / watermark / crop / PDF to PNG | Code implemented; needs real PDF tests |
| OCR moved, Copy/Download, File Converter output preview | Code implemented; browser QA pending |
| Compare Documents removed, Text Counter retained | Built |
| Zrain UI Golden Reference | Synced and verified by Windows deployment script before deploy |
| Zrain Community IDs | Preserved; new IDs require admin registration |
| Cloudflare deployment of v2.3 | **Confirmed by user through five Wrangler deployment logs; not performed from this environment** |
| Full real mobile device QA | **NOT performed** |

Both v2.2.0 and v2.3.0 Cloudflare Pages deployments were confirmed by the user. v2.4.0 deployed to all five Cloudflare Pages sites according to the owner-provided Wrangler log; real-device verification remains separate. The authoring environment blocks localhost navigation in Chromium. CLI unit/static tests are not a substitute for live functionality or manual quality review.

