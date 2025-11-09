#!/usr/bin/env python3
"""
Script to generate all SQL join animations using Manim.
Run this after installing manim: pip install manim
"""

import os
import subprocess
from pathlib import Path

# Animation configurations (only the three currently implemented)
ANIMATIONS = [
    {"file": "inner_join.py", "scene": "InnerJoinScene", "output": "inner_join"},
    {"file": "left_join.py", "scene": "LeftJoinScene", "output": "left_join"},
    {"file": "full_outer_join.py", "scene": "FullOuterJoinScene", "output": "full_outer_join"},
]

# Quality settings
QUALITY = "l"  # Options: l (low), m (medium), h (high)
FORMAT = "mp4"  # Options: mp4, gif, png

def generate_animation(file, scene, output, quality=QUALITY):
    """Generate a single animation using Manim."""
    print(f"\n{'='*60}")
    print(f"Generating {output}...")
    print(f"{'='*60}\n")
    
    cmd = [
        "manim",
        f"-pq{quality}",
        file,
        scene
    ]
    
    try:
        subprocess.run(cmd, check=True)
        print(f"✓ Successfully generated {output}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"✗ Error generating {output}: {e}")
        return False
    except FileNotFoundError:
        print("✗ Error: Manim is not installed or not in PATH")
        print("   Install it with: pip install manim")
        return False

def copy_to_static():
    """Copy generated videos to the static/animations directory."""
    print(f"\n{'='*60}")
    print("Copying files to static/animations...")
    print(f"{'='*60}\n")
    
    # Get the project root (parent of manim_scripts)
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    static_dir = project_root / "static" / "animations"
    
    # Create static/animations directory if it doesn't exist
    static_dir.mkdir(parents=True, exist_ok=True)
    
    # Manim output directory
    media_dir = script_dir / "media" / "videos"
    
    copied = 0
    for anim in ANIMATIONS:
        # Find the generated video file
        scene_dir = media_dir / Path(anim["file"]).stem / f"{QUALITY}080p{60 if QUALITY == 'l' else 30}"
        video_file = scene_dir / f"{anim['scene']}.mp4"
        
        if video_file.exists():
            dest_file = static_dir / f"{anim['output']}.mp4"
            try:
                import shutil
                shutil.copy2(video_file, dest_file)
                print(f"✓ Copied {anim['output']}.mp4")
                copied += 1
            except Exception as e:
                print(f"✗ Error copying {anim['output']}.mp4: {e}")
        else:
            print(f"✗ Not found: {video_file}")
    
    print(f"\n{'='*60}")
    print(f"Copied {copied}/{len(ANIMATIONS)} files")
    print(f"{'='*60}\n")

def main():
    """Main function to generate all animations."""
    print("\n" + "="*60)
    print(" SQL JOINS ANIMATION GENERATOR")
    print("="*60)
    
    success_count = 0
    for anim in ANIMATIONS:
        if generate_animation(anim["file"], anim["scene"], anim["output"]):
            success_count += 1
    
    print(f"\n{'='*60}")
    print(f"Generated {success_count}/{len(ANIMATIONS)} animations")
    print(f"{'='*60}\n")
    
    if success_count > 0:
        copy_to_static()
        print("\n✓ All done! Animations are ready in static/animations/")
    else:
        print("\n✗ No animations were generated successfully")

if __name__ == "__main__":
    main()
