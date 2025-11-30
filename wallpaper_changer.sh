# #!/bin/bash
#
# # Directory containing wallpapers
# WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
#
# # Check if the wallpaper directory exists
# if [ ! -d "$WALLPAPER_DIR" ]; then
#   echo "Error: Wallpaper directory $WALLPAPER_DIR does not exist."
#   exit 1
# fi
#
# # Function to set a random wallpaper with fade
# set_wallpaper() {
#   # Find all image files (jpg, jpeg, png) in the wallpaper directory
#   mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))
#
#   # Check if there are any wallpapers
#   if [ ${#WALLPAPERS[@]} -eq 0 ]; then
#     echo "Error: No wallpapers found in $WALLPAPER_DIR"
#     exit 1
#   fi
#
#   # Select a random wallpar
#   RANDOM_WALLPAPER=${WALLPAPERS[$RANDOM % ${#WALLPAPERS[@]}]}
#
#   # Log the change
#   echo "Setting wallpaper: $RANDOM_WALLPAPER" >>~/Pictures/Wallpapers/wallpaper_log.txt
#
#   # Fade out the current wallpaper
#   #:w  ~/.config/sway/scripts/fade_helper.py out
#
#   # Kill the old swaybg and start the new one
#   pkill -u "$USER" swaybg
#   swaybg -i "$RANDOM_WALLPAPER" -m fill &
#
#   # Fade in the new wallpaper
#   # ~/.config/sway/scripts/fade_helper.py in
# }
#
# # Run the wallpaper changer in an infinite loop
# while true; do
#   set_wallpaper
#   # Wait for 10 minutes (600 seconds)
#   sleep 600
# done

#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Ensure the directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Error: Wallpaper directory $WALLPAPER_DIR does not exist."
  exit 1
fi

# Start swww daemon if not running
if ! pgrep -x "swww-daemon" >/dev/null; then
  echo "Starting swww-daemon..."
  swww-daemon &
  sleep 1
fi

# Function to set a random wallpaper with a smooth transition
set_wallpaper() {
  mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))

  if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "Error: No wallpapers found in $WALLPAPER_DIR"
    exit 1
  fi

  RANDOM_WALLPAPER=${WALLPAPERS[$RANDOM % ${#WALLPAPERS[@]}]}
  echo "[$(date)] Setting wallpaper: $RANDOM_WALLPAPER" >> "$WALLPAPER_DIR/wallpaper_log.txt"

  swww img "$RANDOM_WALLPAPER" --transition-type any --transition-step 90 --transition-fps 60
}

# Run forever, changing every 10 minutes
while true; do
  set_wallpaper
  sleep 600
done
