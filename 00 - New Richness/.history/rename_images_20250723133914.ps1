# PowerShell Script to Rename Images for jsPsych Experiment
# Run this from the project root directory

Write-Host "Starting image renaming process..." -ForegroundColor Green

# Set the paths
$mainPicturesPath = "stimuli\pictures"
$practiceRegularPath = "stimuli\pictures\practice_regular"
$practiceSimilarPath = "stimuli\pictures\practice_similar"

# Function to rename images in a directory
function Rename-Images {
    param(
        [string]$path,
        [string]$prefix,
        [int]$startNumber = 1
    )
    
    Write-Host "Processing directory: $path" -ForegroundColor Yellow
    
    # Get all JPG files (excluding already renamed ones)
    $files = Get-ChildItem -Path $path -Filter "*.jpg" | Where-Object { $_.Name -notmatch "^image_\d{3}\.jpg$" }
    
    $counter = $startNumber
    foreach ($file in $files) {
        $newName = "{0}{1:D3}.jpg" -f $prefix, $counter
        $newPath = Join-Path $path $newName
        
        # Check if target file already exists
        if (-not (Test-Path $newPath)) {
            Rename-Item -Path $file.FullName -NewName $newName
            Write-Host "  Renamed: $($file.Name) -> $newName" -ForegroundColor Cyan
            $counter++
        } else {
            Write-Host "  Skipped: $newName already exists" -ForegroundColor Yellow
        }
    }
    
    return $counter - $startNumber  # Return number of files renamed
}

# 1. Rename main experimental images
Write-Host "`n=== MAIN EXPERIMENTAL IMAGES ===" -ForegroundColor Magenta
$mainImagesRenamed = Rename-Images -path $mainPicturesPath -prefix "image_" -startNumber 1
Write-Host "Main images renamed: $mainImagesRenamed" -ForegroundColor Green

# 2. Keep practice images in their folders (code will be updated to handle this)
Write-Host "`n=== PRACTICE IMAGES (keeping in folders) ===" -ForegroundColor Magenta
Write-Host "Practice regular images: $(Get-ChildItem -Path $practiceRegularPath -Filter '*.jpg' | Measure-Object | Select-Object -ExpandProperty Count)"
Write-Host "Practice similar images: $(Get-ChildItem -Path $practiceSimilarPath -Filter '*.jpg' | Measure-Object | Select-Object -ExpandProperty Count)"

# 3. Show summary
Write-Host "`n=== SUMMARY ===" -ForegroundColor Green
Write-Host "✓ Main experimental images: $mainImagesRenamed renamed to image_001.jpg - image_$('{0:D3}' -f $mainImagesRenamed).jpg"
Write-Host "✓ Practice images: Kept in separate folders"
Write-Host "✓ SD trial images: Already correctly named (PNG files)"
Write-Host "✓ Test size image: Already correctly named"

Write-Host "`nRenaming complete! Now update your HTML file with the correct image count." -ForegroundColor Green
Write-Host "Update AVAILABLE_MAIN_IMAGES constant to: $mainImagesRenamed" -ForegroundColor Yellow 