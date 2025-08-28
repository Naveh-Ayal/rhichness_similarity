# Simple PowerShell Script to Fill Gaps in image_001.jpg to image_400.jpg sequence

Write-Host "Checking for gaps in image sequence (001-400)..." -ForegroundColor Green

$picturesPath = "stimuli\pictures"
$missingNumbers = @()

# Check which image_XXX.jpg files are missing
Write-Host "Scanning for missing image files..." -ForegroundColor Yellow
for ($i = 1; $i -le 400; $i++) {
    $expectedFile = "image_{0:D3}.jpg" -f $i
    $filePath = Join-Path $picturesPath $expectedFile
    
    if (-not (Test-Path $filePath)) {
        $missingNumbers += $i
        Write-Host "Missing: $expectedFile"
    }
}

# Get all available 000000XXXXXX.jpg files
$oldFormatFiles = Get-ChildItem -Path $picturesPath -Filter "*.jpg" | Where-Object { 
    $_.Name -match "^\d{12}\.jpg$" 
} | Sort-Object Name

Write-Host "Found $($oldFormatFiles.Count) files in 000000XXXXXX.jpg format" -ForegroundColor Cyan
Write-Host "Found $($missingNumbers.Count) missing slots in image_XXX.jpg sequence" -ForegroundColor Cyan

if ($missingNumbers.Count -eq 0) {
    Write-Host "No gaps found! All image_001.jpg to image_400.jpg files exist." -ForegroundColor Green
    exit
}

if ($oldFormatFiles.Count -eq 0) {
    Write-Host "No 000000XXXXXX.jpg files available to fill gaps." -ForegroundColor Yellow
    exit
}

# Fill gaps
Write-Host "Filling gaps..." -ForegroundColor Magenta
$renamedCount = 0
$maxRenames = [Math]::Min($missingNumbers.Count, $oldFormatFiles.Count)

for ($i = 0; $i -lt $maxRenames; $i++) {
    $missingNumber = $missingNumbers[$i]
    $sourceFile = $oldFormatFiles[$i]
    $targetName = "image_{0:D3}.jpg" -f $missingNumber
    
    Rename-Item -Path $sourceFile.FullName -NewName $targetName
    Write-Host "Renamed: $($sourceFile.Name) -> $targetName" -ForegroundColor Green
    $renamedCount++
}

# Summary
Write-Host "SUMMARY:" -ForegroundColor Green
Write-Host "Gaps found: $($missingNumbers.Count)"
Write-Host "Files available to fill gaps: $($oldFormatFiles.Count)"
Write-Host "Gaps filled: $renamedCount"

$remainingGaps = $missingNumbers.Count - $renamedCount
$remainingOldFiles = $oldFormatFiles.Count - $renamedCount

if ($remainingGaps -gt 0) {
    Write-Host "$remainingGaps gaps still remain" -ForegroundColor Yellow
}

if ($remainingOldFiles -gt 0) {
    Write-Host "$remainingOldFiles files in 000000XXXXXX.jpg format still remain" -ForegroundColor Cyan
}

Write-Host "Done!" -ForegroundColor Green 