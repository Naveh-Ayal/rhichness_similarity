import os

# Define your path
folder_path = r'C:\00 - University\00 - Psychology\MyExperiment\jatos_win_java\study_assets_root\Rhichness_Similarity\stimuli\Pictures'

# Get all files and sort them alphabetically
files = sorted([f for f in os.listdir(folder_path) if os.path.isfile(os.path.join(folder_path, f))])

# Check number of files
if len(files) != 400:
    print(f"⚠️ Expected 400 images, found {len(files)}. Aborting.")
else:
    for i, filename in enumerate(files, start=1):
        ext = os.path.splitext(filename)[1]  # Get the file extension
        new_name = f"image_{str(i).zfill(3)}{ext}"
        src = os.path.join(folder_path, filename)
        dst = os.path.join(folder_path, new_name)
        os.rename(src, dst)
    print("✅ Renaming complete: image_001 to image_400.")
