#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Check if the wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Error: Wallpaper directory $WALLPAPER_DIR does not exist."
  exit 1
fi

# Function to set a random wallpaper with fade
set_wallpaper() {
  # Find all image files (jpg, jpeg, png) in the wallpaper directory
  mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))

  # Check if there are any wallpapers
  if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "Error: No wallpapers found in $WALLPAPER_DIR"
    exit 1
  fi

  # Select a random wallpar
  RANDOM_WALLPAPER=${WALLPAPERS[$RANDOM % ${#WALLPAPERS[@]}]}

  # Log the change
  echo "Setting wallpaper: $RANDOM_WALLPAPER" >>~/Pictures/Wallpapers/wallpaper_log.txt

  # Fade out the current wallpaper
  #:w  ~/.config/sway/scripts/fade_helper.py out

  # Kill the old swaybg and start the new one
  pkill -u "$USER" swaybg
  swaybg -i "$RANDOM_WALLPAPER" -m fill &

  # Fade in the new wallpaper
  # ~/.config/sway/scripts/fade_helper.py in
}

# Run the wallpaper changer in an infinite loop
while true; do
  set_wallpaper
  # Wait for 10 minutes (600 seconds)
  sleep 600
done
