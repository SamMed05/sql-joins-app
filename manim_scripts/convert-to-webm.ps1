# Convert MP4 videos to WebM format for QtWebEngine compatibility
# This script uses ffmpeg to convert all MP4 files in static/animations to WebM

$animationsDir = "static\animations"
$mp4Files = Get-ChildItem -Path $animationsDir -Filter "*.mp4"

Write-Host "Converting MP4 videos to WebM format..." -ForegroundColor Green
Write-Host "Found $($mp4Files.Count) MP4 file(s) to convert`n" -ForegroundColor Cyan

foreach ($mp4File in $mp4Files) {
    $inputPath = $mp4File.FullName
    $outputPath = $inputPath -replace '\.mp4$', '.webm'
    
    Write-Host "Converting: $($mp4File.Name) -> $($mp4File.BaseName).webm" -ForegroundColor Yellow
    
    # Using VP9 codec with good quality settings
    # -c:v vp9: VP9 video codec (modern, efficient)
    # -crf 30: Quality level (lower = better quality, 23-32 is good range)
    # -b:v 0: Variable bitrate mode
    # -c:a libopus: Opus audio codec (best for WebM)
    # -b:a 128k: Audio bitrate
    ffmpeg -i $inputPath `
        -c:v vp9 `
        -crf 30 `
        -b:v 0 `
        -c:a libopus `
        -b:a 128k `
        $outputPath
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Successfully converted: $($mp4File.BaseName).webm`n" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Failed to convert: $($mp4File.Name)`n" -ForegroundColor Red
    }
}

Write-Host "`nConversion complete!" -ForegroundColor Green
Write-Host "You can now delete the original MP4 files if the WebM versions work correctly." -ForegroundColor Cyan
