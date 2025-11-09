# Animations Folder

This folder contains pre-rendered Manim animation videos for SQL joins.

## Expected Files

The following animation files should be placed in this directory (some don't exist yet):

- `inner_join.mp4` - INNER JOIN animation ✅
- `left_join.mp4` - LEFT JOIN animation ✅
- `right_join.mp4` - RIGHT JOIN animation ❌
- `left_anti_join.mp4` - LEFT ANTI JOIN animation ❌
- `right_anti_join.mp4` - RIGHT ANTI JOIN animation ❌
- `full_outer_join.mp4` - FULL OUTER JOIN animation ✅
- `full_anti_join.mp4` - FULL ANTI JOIN animation ❌

## Generating Animations

From the project root:

```bash
cd manim_scripts
pip install -r requirements.txt
python generate_all.py
```

The script will automatically copy generated videos here.

## File Size

Videos are optimized for web delivery (~1-5 MB each). To further compress:

```bash
ffmpeg -i input.mp4 -vcodec libx264 -crf 28 output.mp4
```
