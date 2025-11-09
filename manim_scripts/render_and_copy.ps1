param(
    [Parameter(Mandatory=$true)][string]$File,          # e.g. inner_join.py
    [Parameter(Mandatory=$true)][string]$Scene,         # e.g. InnerJoin
    [string]$Name,                                      # output name in static/animations (default: file stem)
    [ValidateSet('l','m','h')][string]$Quality = 'h',   # l=480p15, m=720p30, h=1080p60
    [int]$Crf = 28                                      # ffmpeg quality (lower = higher quality)
)

$ErrorActionPreference = 'Stop'

# Paths
$scriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$staticDir   = Join-Path $projectRoot 'static/animations'

if (-not $Name -or [string]::IsNullOrWhiteSpace($Name)) {
    $Name = [System.IO.Path]::GetFileNameWithoutExtension($File)
}

# Ensure static dir
New-Item -ItemType Directory -Force -Path $staticDir | Out-Null

# Run manim render
Push-Location $scriptDir
try {
    Write-Host "Rendering with manim (render -q $Quality -p $File $Scene) ..." -ForegroundColor Cyan
    & manim render -q $Quality -p -- $File $Scene
    if ($LASTEXITCODE -ne 0) {
        throw "Manim exited with code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}

# Resolve manim output path based on quality
$qFolder = switch ($Quality) {
    'l' { '480p15' }
    'm' { '720p30' }
    'h' { '1080p60' }
}

$stem    = [System.IO.Path]::GetFileNameWithoutExtension($File)
$inFile  = Join-Path $scriptDir ("media/videos/{0}/{1}/{2}.mp4" -f $stem, $qFolder, $Scene)
if (-not (Test-Path $inFile)) {
    throw "Manim output not found: $inFile"
}

# Compress (if ffmpeg available) to temp, else pass-through
$ffmpeg = Get-Command ffmpeg -ErrorAction SilentlyContinue
$dest   = Join-Path $staticDir ("{0}.mp4" -f $Name)

if ($ffmpeg) {
    $tmpOut = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), ("{0}.tmp.mp4" -f $Name))
    if (Test-Path $tmpOut) { Remove-Item $tmpOut -Force }
    Write-Host "Compressing with ffmpeg (CRF=$Crf) ..." -ForegroundColor Cyan
    & ffmpeg -y -i $inFile -vcodec libx265 -crf $Crf -pix_fmt yuv420p -movflags +faststart $tmpOut
    Move-Item -Force $tmpOut $dest
}
else {
    Write-Host "ffmpeg not found — copying original file without compression." -ForegroundColor Yellow
    Copy-Item -Force $inFile $dest
}

Write-Host "Saved -> $dest" -ForegroundColor Green
