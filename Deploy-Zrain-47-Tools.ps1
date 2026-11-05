# Pembangun / Developer: Zrain
# Deploy only the five existing Cloudflare Pages projects. No new billing.
[CmdletBinding()]
param([switch]$BuildOnly)
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -LiteralPath $root

function Assert-LastCommand([string]$what) {
  if ($LASTEXITCODE -ne 0) { throw "$what failed (exit code $LASTEXITCODE). Aborting." }
}
function Assert-FileHash([string]$path, [string]$expected) {
  $actual = (& git hash-object -- $path 2>&1 | Out-String).Trim()
  Assert-LastCommand "Hash $path"
  if ($actual -ne $expected) { throw "Official Zrain UI hash mismatch for $path. Expected $expected, got $actual. Aborting." }
}
foreach ($command in @('git','node','npm','npx')) {
  if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
    throw "Missing prerequisite '$command'. Install Git and Node.js 20.11+ before deploying."
  }
}
$nodeVersion = (& node -p "process.versions.node" | Out-String).Trim()
Assert-LastCommand 'Read Node version'
$parts = $nodeVersion.Split('.')
if ([int]$parts[0] -lt 20 -or ([int]$parts[0] -eq 20 -and [int]$parts[1] -lt 11)) {
  throw "Node.js 20.11+ is required. Detected $nodeVersion."
}

Write-Host "`n=== ZRAIN UI GOLDEN REFERENCE ===" -ForegroundColor Cyan
# Official approved 2026-11-04 commit; pin the exact files, not mutable main.
$commit = 'a109401fa591afa9f66479fa8d86f1ed1679d70b'
$assets = @(
  @{Remote='src/zrain-ui.js';Local='src/zrain-ui.js';Sha='99aaa486a3ec58125bb7c69c0ad2d340ed8b82ad'},
  @{Remote='src/brand.css';Local='src/brand.css';Sha='9e4c2274bd0a5b10e7aa65314a2fbe964f5223a5'},
  @{Remote='assets/zrain-logo.webp';Local='src/zrain-logo.webp';Sha='e534a195a42465951eaccfd5861b542b1e08277f'}
)
$staged = @()
try {
  foreach ($asset in $assets) {
    $uri = "https://raw.githubusercontent.com/zrain03/zrain-ui/$commit/$($asset.Remote)"
    $tempFile = Join-Path $env:TEMP ("zrain-ui-" + [guid]::NewGuid().ToString('N'))
    Invoke-WebRequest -Uri $uri -OutFile $tempFile -TimeoutSec 45 -UseBasicParsing
    Assert-FileHash $tempFile $asset.Sha
    $staged += @{Temp=$tempFile;Destination=(Join-Path $root $asset.Local)}
  }
  foreach ($item in $staged) {
    Copy-Item -LiteralPath $item.Temp -Destination $item.Destination -Force
  }
  foreach ($asset in $assets) { Assert-FileHash (Join-Path $root $asset.Local) $asset.Sha }
} finally {
  foreach ($item in $staged) { Remove-Item -LiteralPath $item.Temp -Force -ErrorAction SilentlyContinue }
}
Write-Host "Official Zrain UI synced and SHA-verified: $commit" -ForegroundColor Green

Write-Host "`n=== BUILD + UNIT TESTS ===" -ForegroundColor Cyan
& npm run check
Assert-LastCommand 'npm run check'

# Additional independent release checks must pass before touching production.
& node 'scripts/release-preflight.mjs'
Assert-LastCommand 'release preflight'

if ($BuildOnly) {
  Write-Host "`nBuild-only completed. Cloudflare production has NOT been modified." -ForegroundColor Yellow
  exit 0
}

Write-Host "`n=== CLOUDFLARE AUTH CHECK ===" -ForegroundColor Cyan
& npx wrangler whoami
Assert-LastCommand 'Cloudflare authentication check'

$families = @('zrain-image-tools','zrain-pdf-tools','zrain-document-tools','zrain-developer-tools','zrain-productivity-tools')
$completed = @()
foreach ($family in $families) {
  Write-Host "`n=== DEPLOY $family ===" -ForegroundColor Cyan
  & npx wrangler pages deploy (Join-Path 'dist' $family) --project-name $family --branch main
  Assert-LastCommand "Cloudflare Pages deployment of $family. Already deployed: $($completed -join ', ')"
  $completed += $family
}
Write-Host "`nFive Cloudflare Pages deployments finished. Checking public routes..." -ForegroundColor Green
$checks = @(
  'https://zrain-image-tools.pages.dev/emoji-art/',
  'https://zrain-image-tools.pages.dev/image-to-binary-art/',
  'https://zrain-pdf-tools.pages.dev/split-pdf/',
  'https://zrain-document-tools.pages.dev/file-converter/',
  'https://zrain-developer-tools.pages.dev/text-counter/',
  'https://zrain-productivity-tools.pages.dev/teleprompter/'
)
foreach ($url in $checks) {
  try {
    $page = Invoke-WebRequest -Uri $url -TimeoutSec 25 -MaximumRedirection 4 -UseBasicParsing
    if ($page.StatusCode -ne 200) { throw "HTTP $($page.StatusCode)" }
    Write-Host "OK $url" -ForegroundColor Green
  } catch {
    Write-Warning "Production page needs manual verification: $url ($($_.Exception.Message))"
  }
}
Write-Host "`nDeployment requests completed. Check every tool on a real phone, including Community registration and PDF/Office exports." -ForegroundColor Yellow
