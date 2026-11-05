# Zrain Tools v2.4.0 | Targeted PDF and File Converter improvements

**Developed by Zrain**  
**Made for people. Built with purpose.**  
**Explore the Zrain Ecosystem:** https://zrain.web.app

This is a full source release for **46 tools across five independent Cloudflare Pages sites**: 18 Image, 12 PDF, 2 Document, 11 Developer and 3 Productivity. Names are sorted Aâ€“Z within each family. The application keeps the official Zrain UI Golden Reference and Zrain Community embed per tool ID. No new paid service, login or billing has been introduced.

## Changes from v2.3.0

See `RELEASE-v2.4.0.md` for the four approved fixes only: long-distance touch/desktop PDF rearrangement and delete confirmation; live custom PDF watermark color; explicit all/selected page scopes for PDF cropping; and a richer local Word-to-PDF print preview that retains basic document styling but cannot guarantee exact Microsoft Word page layout.

## Retained improvements from v2.3.0

- **Image Cropper**: move/resize crop rectangle with touch or mouse; numeric Left, Top, Width, Height remain editable and synchronize with the visual rectangle. Both input and cropped-result previews remain visible.
- **Add Image Watermark**: drag watermark text to position, drag handle to resize; font size is synchronized with the control. Numeric input remains available.
- **Compress Image**: automatic encoding/resize tries to produce an output smaller than the uploaded file. A larger output is **never** offered; the user receives an explanation if further compression cannot be achieved. Strong compression may reduce image dimensions/quality. Defaulting to 100% JPEG quality would often increase file size, so 100% is not appropriate for a compression tool.
- **Background Remover**: experimental local UÂ²-Netp AI cutout with transparent, white, black or custom color background. No edge tolerance/softness inputs. First use loads a pinned Apache-2.0 ONNX model (~4.6 MB) and ONNX Runtime Web from third-party hosts. This is **not the remove.bg API**, and quality parity with remove.bg is not promised. No image is intentionally uploaded to a server; processing is in the user's browser. Real device and model download tests remain REQUIRED before considering this production-ready.
- **Rearrange PDF Pages**: thumbnail preview of real PDF pages and drag-to-reorder, plus move-earlier/move-later touch-friendly buttons.
- **PDF Watermark**: draggable/resizable visual text overlay, numeric size, opacity/color, choice of all PDF pages or selected page numbers.
- **Crop PDF**: visual drag/resize area with synchronized editable margin numbers. Cropping **does not erase hidden PDF content** and must never be used for redaction.
- **PDF to Images**: per-page thumbnails, individual PNG preparation and download, or all page PNGs in a ZIP.
- **Extract Text from Image** moved from Document Tools to Image Tools; new Copy and Download TXT actions, text remains editable.
- **File Converter**: shows previews of generated PDF and image output as well as text/data excerpts from DOCX and XLSX output when available. Office previews are **not pixel-perfect**, and conversion can lose complex layouts.
- **Compare Documents**: retired because output was not reliably useful. Its old URL redirects to the document family; no data is deleted.
- **Text Counter**: remains available in Developer Tools. It was already present; no duplicate created.
- Old generic question-mark tooltips and verbose help remain removed. All original core operations remain reachable.

## Windows deployment to five existing Cloudflare Pages products

**Do not delete or overwrite** the current `C:\Users\<your-user>\Downloads\Zrain\Projects\zrain-tools` project folder until live verification and a backup are complete. The ZIP extracts to `Zrain-47-Tools-Release` for compatibility with the existing tested deployment workflow. The folder name is historical; the real build contains 46 tools.

From the extracted release folder in PowerShell:

```powershell
Unblock-File .\Deploy-Zrain-47-Tools.ps1
.\Deploy-Zrain-47-Tools.ps1 -BuildOnly
```

This synchronizes the approved Zrain UI Golden Reference, builds output, runs unit tests and strict preflight, but **does not deploy**. Inspect the local site (`npm start`) and test all workflows on a real phone before removing `-BuildOnly`:

```powershell
.\Deploy-Zrain-47-Tools.ps1
```

Requires Node.js >=20.11, `git`, `npm`, `npx`, logged-in Cloudflare Wrangler and the **five existing** Pages projects. The script never creates a new billing account or D1 database. It does not edit the Ecosystem catalog or Community database. The deprecated `Compare Documents` Community history remains untouched.

## Tests and limits

Run `npm run check`; do **not** treat a passing test suite as proof of successful conversion or successful model inference. Some PDF and OCR tools need third-party CDN libraries. The AI background model and ONNX Runtime can be unavailable, blocked by browser policy, or return imperfect cutouts. Complex PDF, DOCX, XLSX and OCR outputs require representative real-file tests. The test browser environment currently blocks localhost navigation; mobile drag/touch and actual browser exports have not been validated.

The documentation here describes implementation intent and code-backed behavior, not verified end-to-end guarantees. On 2026-11-05, the owner confirmed five successful v2.4.0 Cloudflare Pages deployments and six passing HTTP route checks. These checks do not guarantee all functions or mobile interactions work end to end.

## Community migration

The ID for Extract Text from Image remains `text-extractor`, now hosted under Image Tools. Community conversations use the same ID; only the web URL changes. `Compare Documents` ID stays in the Community database for historical records but is not exposed as a public tool. New art and counter IDs may still need registration by an authenticated Zrain Community administrator. See `Zrain-Community-46-Tools-Manifest.json`.

## Developer notices

The UÂ²-Netp model has an Apache-2.0 license; model author/source and the runtime dependency are documented under `licenses/`. The full model weights are not included in the ZIP. JSZip and QR license notices are kept. Keep the official Zrain logo, footer-only tagline and product-scoped Community ID.

