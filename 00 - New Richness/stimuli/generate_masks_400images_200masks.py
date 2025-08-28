
import os
import random
from PIL import Image

# --- Configuration ---
input_folder = "pictures"
output_folder = "masks"
num_images = 400
tiles_per_image = 4
grid_rows = grid_cols = 40
tile_size = 16  # Since 640/40 = 16
mask_size = (grid_cols * tile_size, grid_rows * tile_size)

# --- Create output folder ---
os.makedirs(output_folder, exist_ok=True)

# --- Load images ---
image_paths = sorted([
    os.path.join(input_folder, fname)
    for fname in os.listdir(input_folder)
    if fname.lower().startswith('image_')
])[:num_images]


assert len(image_paths) == num_images, f"Expected {num_images} images, found {len(image_paths)}"

# --- Tile each image and sample tiles ---
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
for mask_idx in range(200):
    selected_tiles = [tile for tiles in image_tiles for tile in tiles]
    random.shuffle(selected_tiles)

    mask = Image.new("RGB", mask_size)
    for idx, tile in enumerate(selected_tiles):
        row, col = divmod(idx, grid_cols)
        mask.paste(tile, (col * tile_size, row * tile_size))

    out_path = os.path.join(output_folder, f"mask_{mask_idx+1:02d}.jpg")
    mask.save(out_path)
