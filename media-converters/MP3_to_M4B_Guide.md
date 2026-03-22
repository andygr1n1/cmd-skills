# Converting MP3 Files to M4B Audiobook (iTunes/Apple Books)

This guide walks you through combining multiple MP3 files into a single `.m4b` audiobook file compatible with iTunes and Apple Books on Windows.

## Requirements

- Windows 10/11 with `winget` (Windows Package Manager)
- PowerShell (pwsh)
- FFmpeg (installed via the steps below)

---

## Step 1 — Install FFmpeg

Open PowerShell and run:

```powershell
winget install ffmpeg
```

After installation, **restart your terminal** so the `ffmpeg` command is available on your PATH.

> If you don't want to restart, you can manually refresh the PATH in your current session:
> ```powershell
> $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
> ```

---

## Step 2 — Prepare Your MP3 Files

Place all your `.mp3` files into a single folder. The files will be sorted **alphabetically by filename**, so make sure your filenames are numbered correctly (e.g. `1-01 - Chapter.mp3`, `1-02 - Chapter.mp3`, etc.) to ensure the correct playback order.

---

## Step 3 — Generate the File List

FFmpeg needs a plain text list of files to concatenate. Run the following command from PowerShell, replacing the folder path with your own:

```powershell
$folder = "C:\path\to\your\mp3\folder"

$files = Get-ChildItem $folder -Filter "*.mp3" | Sort-Object Name
$lines = $files | ForEach-Object { "file '$($_.FullName.Replace('\', '/'))'" }
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllLines("$folder\filelist.txt", $lines, $utf8NoBom)
```

> **Important:** The file list must be written with **UTF-8 without BOM** encoding. Using ASCII encoding will corrupt non-Latin characters (e.g. Cyrillic, Chinese) in filenames.

This creates a `filelist.txt` in your folder that looks like:

```
file 'C:/path/to/your/mp3/folder/1-01 - Chapter One.mp3'
file 'C:/path/to/your/mp3/folder/1-02 - Chapter Two.mp3'
...
```

---

## Step 4 — Convert to M4B

Run FFmpeg to concatenate all MP3s and re-encode them as AAC audio inside an M4B container:

```powershell
$folder = "C:\path\to\your\mp3\folder"

ffmpeg -y -f concat -safe 0 -i "$folder\filelist.txt" -c:a aac -b:a 128k "$folder\audiobook.m4b"
```

### What the flags mean

| Flag | Meaning |
|------|---------|
| `-y` | Overwrite output file without asking |
| `-f concat` | Use the concat demuxer (reads a file list) |
| `-safe 0` | Allow absolute paths in the file list |
| `-i filelist.txt` | Input: the file list generated in Step 3 |
| `-c:a aac` | Re-encode audio to AAC (required for M4B/iTunes) |
| `-b:a 128k` | Audio bitrate — 128kbps is good quality for audiobooks |
| `audiobook.m4b` | Output file |

---

## Step 5 — Add to iTunes / Apple Books

1. Open **iTunes** or **Apple Books** on your Mac or PC.
2. Drag and drop `audiobook.m4b` into the library, or use **File → Add to Library**.
3. The file will appear under **Audiobooks** and will support:
   - Bookmarking (resume where you left off)
   - Playback speed control
   - Chapter navigation (if chapters were embedded)

---

## Full One-Shot Script

Copy and paste this entire block into PowerShell to do everything in one go:

```powershell
# ---- CONFIGURE THIS ----
$folder = "C:\path\to\your\mp3\folder"
$output = "$folder\audiobook.m4b"
# -------------------------

# Refresh PATH (in case ffmpeg was just installed)
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

# Generate file list (UTF-8 without BOM to support non-Latin filenames)
$files = Get-ChildItem $folder -Filter "*.mp3" | Sort-Object Name
$lines = $files | ForEach-Object { "file '$($_.FullName.Replace('\', '/'))'" }
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllLines("$folder\filelist.txt", $lines, $utf8NoBom)

# Convert
ffmpeg -y -f concat -safe 0 -i "$folder\filelist.txt" -c:a aac -b:a 128k $output

Write-Host "Done! Audiobook saved to: $output"
```

---

## Bonus — Creating an M4B with Chapters

If you want each MP3 to appear as a **named chapter** in iTunes/Apple Books/iPhone, you can embed chapter markers into the M4B. The chapter titles will be taken from each MP3's filename.

### How it works

1. `ffprobe` reads the duration of each MP3
2. A chapter metadata file is built with cumulative timestamps
3. FFmpeg re-encodes the audio and injects the chapter markers

### Script

```powershell
# ---- CONFIGURE THIS ----
$folder = "C:\path\to\your\mp3\folder"
$output = "$folder\audiobook_chapters.m4b"
# -------------------------

# Refresh PATH (in case ffmpeg was just installed)
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

# Generate file list (UTF-8 without BOM to support non-Latin filenames)
$files = Get-ChildItem $folder -Filter "*.mp3" | Sort-Object Name
$lines = $files | ForEach-Object { "file '$($_.FullName.Replace('\', '/'))'" }
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllLines("$folder\filelist.txt", $lines, $utf8NoBom)

# Build chapter metadata file
$currentMs = 0
$meta = ";FFMETADATA1`n`n"

foreach ($file in $files) {
    $duration = & ffprobe -v quiet -show_entries format=duration -of csv=p=0 $file.FullName
    $durationMs = [long]([double]$duration * 1000)
    $meta += "[CHAPTER]`nTIMEBASE=1/1000`nSTART=$currentMs`nEND=$($currentMs + $durationMs)`ntitle=$($file.BaseName)`n`n"
    $currentMs += $durationMs
}

[System.IO.File]::WriteAllText("$folder\chapters.txt", $meta, $utf8NoBom)

# Re-encode with chapters embedded
ffmpeg -y -f concat -safe 0 -i "$folder\filelist.txt" -i "$folder\chapters.txt" -map_metadata 1 -c:a aac -b:a 128k $output

Write-Host "Done! Chaptered audiobook saved to: $output"
```

### Notes

- Chapter titles are taken from the **filename** (without extension), e.g. `1-01 - Шелест утренних звезд`
- The resulting `.m4b` will show a chapter list on iPhone, iPad, and in iTunes/Apple Books
- This script also regenerates `filelist.txt`, so it can be run standalone without running the basic script first

---

## Notes & Troubleshooting

### Why can't I just copy the MP3 audio into M4B without re-encoding?
The M4B container (based on MPEG-4/iPod format) does **not** support MP3 audio streams. FFmpeg will error with `codec not currently supported in container`. Re-encoding to AAC is required.

### How long does conversion take?
FFmpeg re-encodes at roughly **35–40x real-time speed**. A 35-hour audiobook will take approximately **1 hour** of actual processing time.

### The FFmpeg progress shows a large time value — is it stuck?
No. The time shown (e.g. `time=03:50:00`) is the **audio duration processed**, not the wall clock time elapsed. Check the `speed=` value — anything above `1x` means it is progressing normally.

### My filenames contain non-Latin characters (Russian, Chinese, etc.) and it fails
Make sure you use the UTF-8 without BOM method in Step 3. Using `-Encoding ascii` in PowerShell will replace non-ASCII characters with `?`, causing FFmpeg to fail to find the files.

### Can I adjust audio quality?
Yes — change `-b:a 128k` to a different bitrate:
- `64k` — smaller file, lower quality (acceptable for speech)
- `128k` — recommended for audiobooks
- `192k` — higher quality, larger file
