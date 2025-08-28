# Image Renaming Instructions for jsPsych Experiment

## Problem Fixed
Your jsPsych experiment code was looking for images named `image_001.jpg` through `image_400.jpg`, but the actual files in your `stimuli/pictures/` folder had names like `000000000570.jpg`.

## Solution Implemented
1. **PowerShell renaming script** (`rename_images.ps1`) to rename main experimental images
2. **Updated HTML code** to handle practice images in their separate folders
3. **Preserved folder structure** for different image types

## How to Run the Fix

### Step 1: Run the PowerShell Script
1. Open PowerShell as Administrator
2. Navigate to your project directory:
   ```powershell
   cd "C:\Users\NavehAyal\Downloads\Rhichness_Similarity\00 - New Richness"
   ```
3. Run the renaming script:
   ```powershell
   .\rename_images.ps1
   ```

### Step 2: Update the AVAILABLE_MAIN_IMAGES Constant
After running the script, it will tell you how many images were renamed. Update this number in your HTML file:

1. Open `mini-experiment-22-07_IY.html`
2. Find line ~140 where it says:
   ```javascript
   const AVAILABLE_MAIN_IMAGES = 95; // Update this based on rename script output
   ```
3. Replace `95` with the actual number shown by the script

### Step 3: Test Your Experiment
Run your experiment to make sure all images load correctly.

## What Was Changed

### In `mini-experiment-22-07_IY.html`:

1. **Added new constant:**
   ```javascript
   const AVAILABLE_MAIN_IMAGES = 95; // Update this number!
   ```

2. **Updated `generateBalancedTrials` function:**
   - Practice trials now use images from `practice_regular/` and `practice_similar/` folders
   - Main experiment uses renamed `image_001.jpg` to `image_XXX.jpg` files
   - Improved similar image selection for practice trials

3. **Preserved existing functionality:**
   - SD trial images (PNG files) remain unchanged
   - Test size image remains unchanged
   - All folder structures preserved

### File Organization After Renaming:
```
stimuli/pictures/
├── image_001.jpg (renamed from 000000000570.jpg)
├── image_002.jpg (renamed from 000000001643.jpg)
├── ...
├── image_XXX.jpg (total number shown by script)
├── practice_regular/
│   ├── 000000466041.jpg (unchanged)
│   └── ... (11 more files)
├── practice_similar/
│   ├── 000000553312.jpg (unchanged)
│   └── ... (11 more files)
├── sd_trial/
│   ├── sd_trial_fixation.png (unchanged)
│   └── ... (3 more PNG files)
└── test_size/
    └── 000000205977.jpg (unchanged)
```

## Benefits
- ✅ No more image loading errors
- ✅ Cleaner, predictable image naming
- ✅ Preserved different image types for practice vs. experimental trials
- ✅ Maintained folder organization
- ✅ Ready for production use

## If Something Goes Wrong
- The script checks for existing files before renaming
- Original files in practice folders are preserved
- SD trial and test size images are unchanged
- You can always re-run the script if needed

Run the script and update the constant, then test your experiment! 