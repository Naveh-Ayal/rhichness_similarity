import os
import random
from PIL import Image

# --- Configuration ---
input_folder = "pictures"
output_folder = "masks"
num_images = 40
tiles_per_image = 40
grid_rows = grid_cols = 40
tile_size = 16  # Since 640/40 = 16 tiles per dimension
mask_size = (grid_cols * tile_size, grid_rows * tile_size)

# --- Create output folder ---
os.makedirs(output_folder, exist_ok=True)

# --- Load images ---
image_paths = sorted([
    os.path.join(input_folder, fname)
    for fname in os.listdir(input_folder)
    if fname.lower().endswith(('.jpg', '.jpeg', '.png'))
])[:num_images]

assert len(image_paths) == num_images, f"Expected {num_images} images, found {len(image_paths)}"

# --- Tile each image and sample 40 tiles ---
image_tiles = []
for path in image_paths:
    img = Image.open(path).convert("RGB")
    img = img.resize((640, 640), Image.NEAREST)

    tiles = []
    for i in range(0, 640, tile_size):
        for j in range(0, 640, tile_size):
            tile = img.crop((j, i, j + tile_size, i + tile_size))
            tiles.append(tile)

    sampled = random.sample(tiles, tiles_per_image)
    image_tiles.append(sampled)

# --- Generate masks ---
for mask_idx in range(30):
    selected_tiles = [tile for tiles in image_tiles for tile in tiles]
    random.shuffle(selected_tiles)

    mask = Image.new("RGB", mask_size)
    for idx, tile in enumerate(selected_tiles):
        row, col = divmod(idx, grid_cols)
        mask.paste(tile, (col * tile_size, row * tile_size))

    out_path = os.path.join(output_folder, f"mask_{mask_idx + 1:02d}.jpg")
    mask.save(out_path)

# --- Write log file ---
log_path = os.path.join(output_folder, "mask_generation_info.txt")
with open(log_path, "w") as log:
    log.write("🧩 Mask Generation Summary\n")
    log.write("--------------------------\n")
    log.write(f"Image size: 640 x 640 px\n")
    log.write(f"Grid size: {grid_rows} x {grid_cols} (1600 tiles)\n")
    log.write(f"Tiles per image: {tiles_per_image}\n")
    log.write(f"Number of images used: {num_images}\n")
    log.write(f"Masks generated: 30\n\n")
    log.write("Images used:\n")
    for path in image_paths:
        log.write(f"- {os.path.basename(path)}\n")

print("✅ Done. Masks and log file saved in:", output_folder)
