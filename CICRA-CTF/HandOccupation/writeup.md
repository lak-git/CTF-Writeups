# Hand Occupation

## Summary

A 14-frame animated GIF (`handoccupation.gif`) shows a hand performing different gestures in each frame. Each gesture corresponds to a character in the ASL alphabet or a fingers-count number; concatenated and read in leetspeak they spell out the flag.

## Solution

### Step 1: Inspect the GIF structure

The file is a small GIF89a, 60x78, 14 frames. `identify` reveals the frame count and `convert -coalesce` splits them into individual PNGs:

```bash
identify handoccupation.gif | wc -l           # 14 frames
convert handoccupation.gif -coalesce frame_%02d.png
```

### Step 2: Detect and discard duplicate frames

Some frames repeat (the GIF loops the sequence). Hashing each frame's pixel data collapses the 14 frames to 11 unique ones, which is the real per-character sequence:

```python
from PIL import Image
import hashlib

hashes = []
for i in range(14):
    img = Image.open(f"frame_{i:02d}.png").convert("RGB")
    h = hashlib.md5(img.tobytes()).hexdigest()
    hashes.append(h)

unique = []
for i, h in enumerate(hashes):
    if h not in unique:
        unique.append(h)
print(f"Unique frames: {len(unique)}/14")
```

### Step 3: Isolate the hand from the background

Each frame has a different background color (detected as the most-common pixel). Subtracting it yields a binary mask of just the hand, which makes the gesture readable:

```python
from PIL import Image
import numpy as np
from collections import Counter

for i in range(14):
    img = Image.open(f"frame_{i:02d}.png").convert("RGB")
    arr = np.array(img)
    pixels = [tuple(int(v) for v in p) for p in arr.reshape(-1, 3)]
    bg = tuple(int(x) for x in Counter(pixels).most_common(1)[0][0])
    diff = np.abs(arr.astype(int) - np.array(bg).astype(int)).sum(axis=2)
    mask = (diff > 30).astype(np.uint8) * 255
    Image.fromarray(mask).save(f"hand_{i:02d}.png")
```

Running the above produces one cleaned binary image per frame, which is what gets matched against the reference charts in the next step.

### Step 4: Decode each gesture with reference charts

The hand in each cleaned frame was identified manually by comparing it against two reference charts stored:

- `ASL-Alphabet.pdf` - ASL fingerspelling alphabet
- `Numbers-chart.pdf` - finger-count number chart (1-10)

- **These were found by reverse image searching the one of the two types of individual frames**

Reading the 11 unique frames in order and applying standard leetspeak substitutions (`4=A`, `0=O`):

```
H 4 N D Y S | J 0 B 6 9 | H 4 N D Y | H 4 S H | J 0 B 6 9 | H
```

The full recovered phrase is:

```
H4NDYSJ0B69H4NDYH4SHJ0B69H
```

### Step 5: Format the flag

The phrase uses leetspeak and the literal substring `H4SH` points at the `HashX{...}` flag format. Words are underscore-separated, giving the final flag.

## Flag

```
HashX{H4NDYS_J0B_69_H4NDY_H4SH_J0B_69_H}
```
