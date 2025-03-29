import os
import random
from PIL import Image

# --- Config ---
input_folder = "Pictures"
output_folder = "Masks"
grid_rows = 5
grid_cols = 6
tile_count = grid_rows * grid_cols
standard_size = (600, 500)  # width x height

# --- Make sure output folder exists ---
os.makedirs(output_folder, exist_ok=True)

# --- Load all image file paths ---
image_paths = sorted([
    os.path.join(input_folder, fname)
    for fname in os.listdir(input_folder)
    if fname.lower().endswith((".jpg", ".jpeg", ".png"))
])[:30]  # use first 30 images

# --- Resize and cut each image into tiles ---
print("Cutting images into tiles...")
image_tiles = []

for path in image_paths:
    img = Image.open(path).convert("RGB")
    img = img.resize(standard_size, Image.NEAREST)  # Ensure consistent size
    w, h = img.size
    tile_w, tile_h = w // grid_cols, h // grid_rows
    tiles = []

    for i in range(grid_rows):
        for j in range(grid_cols):
            box = (j * tile_w, i * tile_h, (j + 1) * tile_w, (i + 1) * tile_h)
            tile = img.crop(box)
            tiles.append(tile)

    image_tiles.append(tiles)

# --- Generate composite mask images ---
print("Creating composite mask images...")
for mask_index in range(tile_count):
    new_tiles = [image_tiles[i][mask_index] for i in range(tile_count)]  # one tile from each image

    mask_img = Image.new("RGB", (tile_w * grid_cols, tile_h * grid_rows), color=(128, 128, 128))  # mid-gray bg

    for idx, tile in enumerate(new_tiles):
        row, col = divmod(idx, grid_cols)
        mask_img.paste(tile, (col * tile_w, row * tile_h))

    mask_path = os.path.join(output_folder, f"mask_{mask_index+1:02d}.jpg")
    mask_img.save(mask_path)

print("✅ Done! Masks saved in:", output_folder)
