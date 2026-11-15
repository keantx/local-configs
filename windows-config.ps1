$ErrorActionPreference = 'Stop'

$candidates = @(
    "$env:LOCALAPPDATA\Programs\Zed\Zed.exe",
    "$env:ProgramFiles\Zed\Zed.exe"
)
$zedExe = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $zedExe) {
    $cmd = Get-Command zed -ErrorAction SilentlyContinue
    if ($cmd) { $zedExe = $cmd.Source }
}

if (-not $zedExe) {
    Write-Warning "Zed is not installed. Nothing to do."
    exit 1
}
Write-Host "Zed found: $zedExe"

$zedDir = Join-Path $env:APPDATA 'Zed'
New-Item -ItemType Directory -Force -Path $zedDir | Out-Null
Write-Host "Config dir: $zedDir"

$files = [ordered]@{
    'windows-settings.json' = 'settings.json'
    'windows-keymap.json'   = 'keymap.json'
}
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

foreach ($srcName in $files.Keys) {
    $src  = Join-Path $PSScriptRoot $srcName
    $dest = Join-Path $zedDir $files[$srcName]

    if (-not (Test-Path $src)) {
        Write-Warning "Missing $src, skipping."
        continue
    }
    if (Test-Path $dest) {
        Copy-Item $dest "$dest.bak-$stamp"
        Write-Host "Backed up $($files[$srcName]) -> $($files[$srcName]).bak-$stamp"
    }
    Copy-Item $src $dest -Force
    Write-Host "Installed $srcName -> $dest"
}
