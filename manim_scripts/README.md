# Manim Animation Scripts

Python scripts to generate SQL join animations using [Manim](https://www.manim.community/).

**Based on:** [@jmablog's SQL joins animations](https://github.com/jmablog/manim/tree/main/joins)

## Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Generate all animations
python generate_all.py
```

Videos will be copied to `../static/animations/`.

### One-step render + compress + copy (PowerShell)

Use the helper script `render_and_copy.ps1` (requires `ffmpeg` in PATH for compression, otherwise it just copies the original):

```pwsh
pwsh ./render_and_copy.ps1 -File inner_join.py -Scene InnerJoin -Quality h -Crf 28
```

Parameters:

- `-File`    The manim script (e.g. `inner_join.py`)
- `-Scene`   The scene/class name inside the script (e.g. `InnerJoin`)
- `-Name`    Optional output base name (defaults to file stem)
- `-Quality` One of `l|m|h` mapping to 480p15 / 720p30 / 1080p60
- `-Crf`     ffmpeg CRF (default 28; lower = better quality, bigger file)

Result file appears as `static/animations/<Name>.mp4`.

## Individual Animation

```bash
manim -pql inner_join.py InnerJoinScene
```

## Available Scripts

- `inner_join.py` - INNER JOIN ✅
- `left_join.py` - LEFT JOIN ✅
- `full_outer_join.py` - FULL OUTER JOIN ✅
- `left_anti_join.py` - LEFT ANTI JOIN (left-only unmatched rows) 🏗️
- `right_anti_join.py` - RIGHT ANTI JOIN (right-only unmatched rows) 🏗️
- `full_anti_join.py` - FULL ANTI JOIN (unmatched rows from both sides) 🏗️

## Quality Settings

Edit `generate_all.py`:

- `QUALITY = "l"` - Low quality (fast)
- `QUALITY = "m"` - Medium quality
- `QUALITY = "h"` - High quality

You can also render in HD then compress with FFmpeg with something like [this](https://unix.stackexchange.com/questions/28803/how-can-i-reduce-a-videos-size-with-ffmpeg):

```bash
ffmpeg -i input.mp4 -vcodec libx265 -crf 28 output.mp4
```
