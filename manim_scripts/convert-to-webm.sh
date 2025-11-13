#!/bin/bash
# Convert MP4 videos to WebM format for QtWebEngine compatibility
# This script uses ffmpeg to convert all MP4 files in static/animations to WebM

ANIMATIONS_DIR="static/animations"

echo "Converting MP4 videos to WebM format..."
mp4_count=$(find "$ANIMATIONS_DIR" -name "*.mp4" | wc -l)
echo "Found $mp4_count MP4 file(s) to convert"
echo ""

for mp4_file in "$ANIMATIONS_DIR"/*.mp4; do
    if [ -f "$mp4_file" ]; then
        filename=$(basename "$mp4_file" .mp4)
        output_file="$ANIMATIONS_DIR/$filename.webm"
        
        echo "Converting: $(basename "$mp4_file") -> $filename.webm"
        
        # Using VP9 codec with good quality settings
        ffmpeg -i "$mp4_file" \
            -c:v vp9 \
            -crf 30 \
            -b:v 0 \
            -c:a libopus \
            -b:a 128k \
            "$output_file"
        
        if [ $? -eq 0 ]; then
            echo "  ✓ Successfully converted: $filename.webm"
            echo ""
        else
            echo "  ✗ Failed to convert: $(basename "$mp4_file")"
            echo ""
        fi
    fi
done

echo "Conversion complete!"
echo "You can now delete the original MP4 files if the WebM versions work correctly."
