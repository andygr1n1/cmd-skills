# MP3 Metadata Guide

A reference for metadata fields you can modify in MP3 files using ID3 tags.

## Core / Common Fields

| Field | ffmpeg Key | Description |
|-------|------------|-------------|
| **Title** | `title` | Song/track title |
| **Artist** | `artist` | Lead performer/artist |
| **Album** | `album` | Album name |
| **Album Artist** | `album_artist` | Album artist (for compilations) |
| **Genre** | `genre` | Genre (e.g. Pop, Rock) |
| **Year/Date** | `date` | Release year (e.g. 2019) |
| **Track** | `track` | Track number (e.g. 5) |
| **Disc** | `disc` | Disc number |
| **Composer** | `composer` | Composer name |
| **Comment** | `comment` | Free-form comment/notes |

## Additional Fields

| Field | ffmpeg Key | Description |
|-------|------------|-------------|
| **Copyright** | `copyright` | Copyright notice |
| **Publisher** | `publisher` | Record label/publisher |
| **BPM** | `tbpm` | Beats per minute |
| **Lyrics** | `lyrics-XXX` | Lyrics (XXX = language code) |
| **Encoder** | `encoder` | Software used for encoding |
| **Description** | `description` | Short description |
| **Compilation** | `compilation` | 1 = part of compilation album |

## Cover Art (Album Art)

Cover art uses the `APIC` (attached picture) frame. In ffmpeg, you add it with `-i cover.jpg` and map it as the `disposition:attached_pic` stream. Most GUI tag editors have a dedicated "cover art" field.

---

## ffmpeg Examples

### Single file — multiple metadata fields

```bash
ffmpeg -i input.mp3 -metadata title="My Song" -metadata artist="Artist" \
  -metadata album="Album" -metadata genre="Rock" -metadata date="2024" \
  -metadata track="1" -c copy output.mp3
```

### Batch apply metadata to all MP3 files in a folder

```bash
for f in *.mp3; do
  ffmpeg -i "$f" -metadata album="Ringtones" -c copy -y "${f%.mp3}_temp.mp3" && mv "${f%.mp3}_temp.mp3" "$f"
done
```

### Batch apply multiple fields (year, album, artist from filename, etc.)

Useful for a ringtones folder — sets shared metadata and uses each filename as the artist:

```bash
cd /path/to/your/mp3/folder

for f in *.mp3; do
  name="${f%.mp3}"
  ffmpeg -i "$f" \
    -metadata date="2019" \
    -metadata album="Ringtones" \
    -metadata album_artist="Ringtones" \
    -metadata genre="Ringtones" \
    -metadata artist="$name" \
    -c copy -y "${name}_temp.mp3" && mv "${name}_temp.mp3" "$f"
done
```

**Result per file:**
- `year` → 2019
- `album` → Ringtones
- `album_artist` → Ringtones
- `genre` → Ringtones
- `artist` → filename without .mp3 (e.g. `Bomboleio-ringtone.mp3` → artist: **Bomboleio-ringtone**)

### Add cover art to an MP3

```bash
ffmpeg -i cover.jpg -i input.mp3 -map 0 -map 1:a -c copy -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" output.mp3
```
