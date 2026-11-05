# Zrain Tools v2.4.0 | Targeted PDF and File Converter improvements

**Developer:** Zrain  
**Created / updated:** 2026-11-05  
**Status:** Source release. Not deployed by this package. Five existing Cloudflare Pages projects remain unchanged until the operator runs the authenticated deployment script.

## Exactly what changed

- **Rearrange PDF Pages:** Desktop drag-and-drop remains. A touch drag handle now scrolls long page lists automatically while held near the screen edge, allowing moves such as page 1 to page 60. Each page also offers **Move to** as a direct, keyboard-friendly alternative. Removing a page prompts for confirmation; the original uploaded PDF is never modified.
- **PDF Watermark:** Preview color now follows the user's color picker and HEX field immediately. The existing custom color control, text positioning, size, opacity and page scope remain.
- **Crop PDF:** Added explicit choice **All pages** / **Selected pages**, with an initial unselected state. Page-number field appears only for selected pages. The old visual selection and numeric margins remain.
- **File Converter:** Word-to-PDF no longer silently strips formatting into a text-only PDF. Both Word-to-PDF paths now open a locally generated styled print preview, aiming to preserve basic font colors, sizes, alignment, paragraphs, tables and embedded images before **Print > Save as PDF**. PDF-to-Word appearance mode still embeds source-page images for visual fidelity. Editable PDF-to-Word and PDF-to-Excel remain inherently lossy, and the UI keeps those limitations explicit.

## Unchanged

The catalog retains **46 tools across five families**, A-Z ordering, Zrain UI, Zrain Community, no-cost architecture, Text Counter, and all other Image/PDF/Document/Developer/Productivity functionality.

## Known limitations and verification

- Word page breaks, headers/footers, shapes, advanced tab stops, uncommon fonts and exact PDF pagination may differ. No browser-only solution can promise pixel-identical conversion for arbitrary DOCX files. Users must compare printed output with the original.
- Reordering has a tested pure page-order transformation and source-level drag wiring. Test actual scroll gestures and long PDF behavior on Android and iPhone before claiming device completion.
- Test custom watermark color and Crop PDF selected-page output visually in production. Automation does not fully verify mobile touch or document rendering.
- Run `Deploy-Zrain-47-Tools.ps1 -BuildOnly` first. The historically named script is kept for compatibility; its current build has 46 tools.
- The deployment script synchronizes and checks official pinned `@zrain/ui` before building. Never publish assets manually from a package that has not passed this pinned-UI preflight.

## Windows commands (PowerShell)

```powershell
$ErrorActionPreference = 'Stop'
$stage = Join-Path $env:USERPROFILE 'Downloads\Zrain-Tools-v2.4-Staging'
New-Item -ItemType Directory -Path $stage -ErrorAction Stop | Out-Null
Expand-Archive -LiteralPath (Join-Path $env:USERPROFILE 'Downloads\Zrain-46-Tools-Targeted-Fixes-v2.4.0-2026-11-05.zip') -DestinationPath $stage
Set-Location (Join-Path $stage 'Zrain-47-Tools-Release')
Unblock-File '.\Deploy-Zrain-47-Tools.ps1'
& '.\Deploy-Zrain-47-Tools.ps1' -BuildOnly
# Only after preflight and review:
# & '.\Deploy-Zrain-47-Tools.ps1'
```

This script targets only existing Cloudflare Pages projects. It does not write to Zrain Ecosystem, the local master `Zrain\Projects\zrain-tools`, or Community database. Preserve the current master folder until live QA passes.
