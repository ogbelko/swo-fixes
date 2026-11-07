# Fix v12: gives three image files in swo-fixes back their Chinese names (the unzip garbled them).
# Put this file in your swo-fixes folder (the one with fix and PATCH_NOTES.md), right-click it, "Run with PowerShell".
$dir = Join-Path $PSScriptRoot "fix\dl\package\surfaces\xajh\swc"
if (-not (Test-Path -LiteralPath $dir)) { Write-Host "Not found: $dir - put this file in the swo-fixes folder."; Read-Host "Enter to close"; exit 1 }
$cp = [Text.Encoding]::GetEncoding(850)
$names = @((-join([char[]]@(0x5c0f,0x6309,0x94ae,0x005f,0x4e0d,0x53ef,0x7528,0x002e,0x0074,0x0067,0x0061))), (-join([char[]]@(0x64cd,0x4f5c,0x8bbe,0x7f6e,0x5e95,0x677f,0x005f,0x65b0,0x002e,0x0074,0x0067,0x0061,0x002e,0x007a))), (-join([char[]]@(0x9501,0x5b9a,0x005f,0x4e0d,0x53ef,0x7528,0x002e,0x0074,0x0067,0x0061))))
foreach ($n in $names) {
  $bad = $cp.GetString([Text.Encoding]::UTF8.GetBytes($n))
  $src = Join-Path $dir $bad
  if (Test-Path -LiteralPath $src) { Rename-Item -LiteralPath $src -NewName $n; Write-Host "Renamed to $n" }
  elseif (Test-Path -LiteralPath (Join-Path $dir $n)) { Write-Host "Already OK: $n" }
  else { Write-Host "Missing: $n" }
}
Write-Host "Done. Commit and push the 3 renames in GitHub Desktop."
Read-Host "Enter to close"
