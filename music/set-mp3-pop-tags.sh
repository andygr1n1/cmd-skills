#!/usr/bin/env bash
# Set album and genre ID3 tags to "pop" on all MP3 files in a folder.
# Usage:
#   ./set-mp3-pop-tags.sh              # current directory
#   ./set-mp3-pop-tags.sh /path/to/dir # specific folder

set -euo pipefail

ALBUM="${ALBUM:-pop}"
GENRE="${GENRE:-pop}"
DIR="${1:-.}"

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "Error: ffmpeg is required. Install with: brew install ffmpeg" >&2
  exit 1
fi

if [[ ! -d "$DIR" ]]; then
  echo "Error: not a directory: $DIR" >&2
  exit 1
fi

shopt -s nullglob
mp3s=("$DIR"/*.mp3)
shopt -u nullglob

if [[ ${#mp3s[@]} -eq 0 ]]; then
  echo "No MP3 files found in: $(cd "$DIR" && pwd)"
  exit 0
fi

echo "Updating ${#mp3s[@]} file(s) in $(cd "$DIR" && pwd)"
echo "  album=$ALBUM  genre=$GENRE"
echo

for f in "${mp3s[@]}"; do
  tmp="${f}.tagtmp.mp3"
  ffmpeg -y -nostdin -loglevel error -i "$f" \
    -map 0:a -map_metadata 0 -c copy \
    -metadata "album=$ALBUM" -metadata "genre=$GENRE" \
    "$tmp"
  mv "$tmp" "$f"
  echo "  OK: $(basename "$f")"
done

echo
echo "Done."
