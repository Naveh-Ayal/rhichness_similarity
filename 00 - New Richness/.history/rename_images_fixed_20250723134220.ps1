# Fixed PowerShell Script to Rename Images for jsPsych Experiment
# Run this from the project root directory

Write-Host "Starting image renaming process..." -ForegroundColor Green

# Set the paths
$mainPicturesPath = "stimuli\pictures"

Write-Host "`n=== MAIN EXPERIMENTAL IMAGES ===" -ForegroundColor Magenta
Write-Host "Processing directory: $mainPicturesPath" -ForegroundColor Yellow

# Get all JPG files in main directory (excluding subdirectories and already renamed files)
$files = Get-ChildItem -Path $mainPicturesPath -Filter "*.jpg" | Where-Object { 
    $_.Name -match "^\d{12}\.jpg$" 
}

Write-Host "Found $($files.Count) files to rename" -ForegroundColor Cyan

$counter = 1
$renamedCount = 0

foreach ($file in $files) {
    $newName = "image_{0:D3}.jpg" -f $counter
    $newPath = Join-Path $mainPicturesPath $newName
    
    # Check if target file already exists
    if (-not (Test-Path $newPath)) {
        try {
            Rename-Item -Path $file.FullName -NewName $newName -ErrorAction Stop
            Write-Host "  Renamed: $($file.Name) -> $newName" -ForegroundColor Green
            $renamedCount++
        } catch {
            Write-Host "  ERROR renaming $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "  Skipped: $newName already exists" -ForegroundColor Yellow
    }
    $counter++
}

# Show practice image counts
$practiceRegularPath = "stimuli\pictures\practice_regular"
$practiceSimilarPath = "stimuli\pictures\practice_similar"

Write-Host "`n=== PRACTICE IMAGES (keeping in folders) ===" -ForegroundColor Magenta
$practiceRegularCount = (Get-ChildItem -Path $practiceRegularPath -Filter '*.jpg' | Measure-Object).Count
$practiceSimilarCount = (Get-ChildItem -Path $practiceSimilarPath -Filter '*.jpg' | Measure-Object).Count
Write-Host "Practice regular images: $practiceRegularCount" -ForegroundColor Cyan
Write-Host "Practice similar images: $practiceSimilarCount" -ForegroundColor Cyan

# Show summary
Write-Host "`n=== SUMMARY ===" -ForegroundColor Green
Write-Host "Main experimental images: $renamedCount renamed to image_001.jpg - image_$('{0:D3}' -f $renamedCount).jpg" -ForegroundColor Green
Write-Host "Practice images: Kept in separate folders" -ForegroundColor Green
Write-Host "SD trial images: Already correctly named (PNG files)" -ForegroundColor Green
Write-Host "Test size image: Already correctly named" -ForegroundColor Green

Write-Host "`nRenaming complete!" -ForegroundColor Green
Write-Host "UPDATE YOUR HTML FILE: Set AVAILABLE_MAIN_IMAGES = $renamedCount" -ForegroundColor Yellow 