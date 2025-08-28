# PowerShell Script to Fill Gaps in image_001.jpg to image_400.jpg sequence
# This script finds missing image_XXX.jpg files and renames 000000XXXXXX.jpg files to fill the gaps

Write-Host "🔍 Checking for gaps in image sequence (001-400)..." -ForegroundColor Green

$picturesPath = "stimuli\pictures"
$missingNumbers = @()
$availableOldFiles = @()

# Check which image_XXX.jpg files are missing
Write-Host "`n=== SCANNING FOR MISSING IMAGE FILES ===" -ForegroundColor Magenta
for ($i = 1; $i -le 400; $i++) {
    $expectedFile = "image_{0:D3}.jpg" -f $i
    $filePath = Join-Path $picturesPath $expectedFile
    
    if (-not (Test-Path $filePath)) {
        $missingNumbers += $i
        Write-Host "  Missing: $expectedFile" -ForegroundColor Yellow
    }
}

# Get all available 000000XXXXXX.jpg files
Write-Host "`n=== FINDING AVAILABLE 12-DIGIT FILES ===" -ForegroundColor Magenta
$oldFormatFiles = Get-ChildItem -Path $picturesPath -Filter "*.jpg" | Where-Object { 
    $_.Name -match "^\d{12}\.jpg$" 
} | Sort-Object Name

Write-Host "Found $($oldFormatFiles.Count) files in 000000XXXXXX.jpg format" -ForegroundColor Cyan
Write-Host "Found $($missingNumbers.Count) missing slots in image_XXX.jpg sequence" -ForegroundColor Cyan

if ($missingNumbers.Count -eq 0) {
    Write-Host "`n✅ No gaps found! All image_001.jpg to image_400.jpg files exist." -ForegroundColor Green
    exit
}

if ($oldFormatFiles.Count -eq 0) {
    Write-Host "`n⚠️ No 000000XXXXXX.jpg files available to fill gaps." -ForegroundColor Yellow
    exit
}

# Fill gaps
Write-Host "`n=== FILLING GAPS ===" -ForegroundColor Magenta
$renamedCount = 0
$maxRenames = [Math]::Min($missingNumbers.Count, $oldFormatFiles.Count)

for ($i = 0; $i -lt $maxRenames; $i++) {
    $missingNumber = $missingNumbers[$i]
    $sourceFile = $oldFormatFiles[$i]
    $targetName = "image_{0:D3}.jpg" -f $missingNumber
    $targetPath = Join-Path $picturesPath $targetName
    
    try {
        Rename-Item -Path $sourceFile.FullName -NewName $targetName -ErrorAction Stop
        Write-Host "  ✓ Renamed: $($sourceFile.Name) -> $targetName" -ForegroundColor Green
        $renamedCount++
    } catch {
        Write-Host "  ❌ ERROR renaming $($sourceFile.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Summary
Write-Host "`n=== SUMMARY ===" -ForegroundColor Green
Write-Host "Gaps found: $($missingNumbers.Count)" -ForegroundColor Cyan
Write-Host "Files available to fill gaps: $($oldFormatFiles.Count)" -ForegroundColor Cyan
Write-Host "Gaps filled: $renamedCount" -ForegroundColor Green

if ($renamedCount -gt 0) {
    Write-Host "`n✅ Successfully filled $renamedCount gaps in the image sequence!" -ForegroundColor Green
} else {
    Write-Host "`n⚠️ No gaps were filled." -ForegroundColor Yellow
}

# Show remaining gaps and old files
$remainingGaps = $missingNumbers.Count - $renamedCount
$remainingOldFiles = $oldFormatFiles.Count - $renamedCount

if ($remainingGaps -gt 0) {
    Write-Host "`n⚠️ $remainingGaps gaps still remain (not enough old files to fill all gaps)" -ForegroundColor Yellow
}

if ($remainingOldFiles -gt 0) {
    Write-Host "`n📝 $remainingOldFiles files in 000000XXXXXX.jpg format still remain" -ForegroundColor Cyan
    Write-Host "   These can be used for expanding beyond 400 images or kept as backups" -ForegroundColor Gray
} 