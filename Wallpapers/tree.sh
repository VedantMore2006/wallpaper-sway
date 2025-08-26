#!/bin/bash

# Default to current directory if no argument is given
base_dir="${1:-.}"

# Check if input is a valid directory
if [ ! -d "$base_dir" ]; then
  echo "Error: '$base_dir' is not a valid directory." >&2
  exit 1
fi

# Resolve absolute path
base_dir="$(realpath "$base_dir")"

print_tree() {
  local dir="$1"
  local prefix="$2"
  local is_last="$3"

  # Get subdirectories sorted
  local subdirs=()
  while IFS= read -r -d '' subdir; do
    subdirs+=("$subdir")
  done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

  local total=${#subdirs[@]}
  local index=0

  for subdir in "${subdirs[@]}"; do
    ((index++))
    local name=$(basename "$subdir")
    local file_count=$(find "$subdir" -maxdepth 1 -type f | wc -l)
    local count_str=""
    if [ "$file_count" -gt 0 ]; then
      count_str=" ($file_count files)"
    fi

    if [ "$index" -eq "$total" ]; then
      echo "${prefix}└── $name$count_str"
      new_prefix="$prefix    "
    else
      echo "${prefix}├── $name$count_str"
      new_prefix="$prefix│   "
    fi

    # Recursive call
    print_tree "$subdir" "$new_prefix"
  done
}

# Print root
echo "${base_dir}/"
print_tree "$base_dir" ""
