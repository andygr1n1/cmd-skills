# YouTube to MP3 Downloader — Step-by-Step Guide

A complete guide to downloading YouTube videos and playlists as MP3 files using **yt-dlp** and **ffmpeg** on Windows.

---

## Prerequisites

- Windows 10 or 11
- PowerShell (pwsh)
- Internet connection

---

## Step 1 — Install yt-dlp

`yt-dlp` is the core tool that handles downloading from YouTube.

### Option A: via winget (recommended)

Open PowerShell and run:

```powershell
winget install yt-dlp.yt-dlp
```

### Option B: Manual download

1. Go to: https://github.com/yt-dlp/yt-dlp/releases/latest
2. Download `yt-dlp.exe`
3. Move it to a folder that's in your system PATH (e.g. `C:\Windows\System32` or create `C:\Tools` and add it to PATH)

### Verify installation

```powershell
yt-dlp --version
```

You should see a version number like `2024.xx.xx`.

---

## Step 2 — Install ffmpeg

`ffmpeg` is required to convert downloaded audio to MP3 format.

### Option A: via winget (recommended)

```powershell
winget install Gyan.FFmpeg
```

### Option B: Manual download

1. Go to: https://ffmpeg.org/download.html
2. Under "Windows", click **"Windows builds by BtbN"** or **"gyan.dev"**
3. Download the latest **full** or **essentials** build (zip)
4. Extract the zip, go into the `bin` folder
5. Copy `ffmpeg.exe`, `ffprobe.exe`, `ffplay.exe` to `C:\Windows\System32` (or a folder in PATH)

### Verify installation

```powershell
ffmpeg -version
```

> **Important:** After installing both tools, **restart your terminal** so PATH changes take effect.

---

## Step 3 — Basic Usage

### Download a single video as MP3

```powershell
yt-dlp -x --audio-format mp3 --audio-quality 0 "https://www.youtube.com/watch?v=VIDEO_ID"
```

The file will be saved in your **current directory**.

### Download with a custom output filename

```powershell
yt-dlp -x --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s" "URL"
```

---

## Step 4 — Download an Entire Playlist

```powershell
yt-dlp -x --audio-format mp3 --audio-quality 0 `
  -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" `
  "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

This will:

- Create a folder named after the playlist
- Number each track in order
- Save each song as `01 - Song Title.mp3`, `02 - Song Title.mp3`, etc.

---

## Step 5 — Download to a Specific Folder

Replace the output path with your desired music folder:

```powershell
yt-dlp -x --audio-format mp3 --audio-quality 0 `
  -o "C:\Users\YourName\Music\%(title)s.%(ext)s" `
  "URL"
```

---

## Step 6 — Embed Metadata and Thumbnail (Album Art)

For a cleaner music library with proper tags and cover art:

```powershell
yt-dlp -x --audio-format mp3 --audio-quality 0 `
  --embed-thumbnail `
  --add-metadata `
  --parse-metadata "%(uploader)s:%(meta_artist)s" `
  -o "%(title)s.%(ext)s" `
  "URL"
```

This embeds:

- **Title** — from video title
- **Artist** — from channel/uploader name
- **Thumbnail** — as album cover art

---

## Step 7 — Recommended All-in-One Command

This is the best general-purpose command for music downloads:

```powershell
yt-dlp -x --audio-format mp3 --audio-quality 0 `
  --embed-thumbnail `
  --add-metadata `
  --no-playlist `
  -o "C:\Users\andygr1n1\Music\%(title)s.%(ext)s" `
  "URL"
```

> Use `--no-playlist` when you paste a video URL that belongs to a playlist but you only want that single video.

---

## Flag Reference

| Flag                            | Description                                           |
| ------------------------------- | ----------------------------------------------------- |
| `-x`                            | Extract audio only (no video)                         |
| `--audio-format mp3`            | Convert to MP3                                        |
| `--audio-quality 0`             | Best quality (0=best, 9=worst)                        |
| `--audio-quality 192K`          | Fixed bitrate (e.g. 128K, 192K, 320K)                 |
| `-o "..."`                      | Output path and filename template                     |
| `--embed-thumbnail`             | Embed album art into the MP3                          |
| `--add-metadata`                | Write title, artist, etc. into MP3 tags               |
| `--no-playlist`                 | Download only the single video, not the full playlist |
| `--yes-playlist`                | Force download the entire playlist                    |
| `--playlist-start N`            | Start downloading from track number N                 |
| `--playlist-end N`              | Stop downloading at track number N                    |
| `--ignore-errors`               | Skip unavailable videos instead of stopping           |
| `--cookies-from-browser chrome` | Use Chrome cookies (for age-restricted content)       |

---

## Output Template Variables

Use these placeholders in the `-o` path:

| Variable             | Meaning                  |
| -------------------- | ------------------------ |
| `%(title)s`          | Video title              |
| `%(uploader)s`       | Channel name             |
| `%(playlist)s`       | Playlist name            |
| `%(playlist_index)s` | Track number in playlist |
| `%(ext)s`            | File extension (mp3)     |
| `%(id)s`             | YouTube video ID         |
| `%(upload_date)s`    | Upload date (YYYYMMDD)   |

---

## Batch Download from a Text File

Create a file called `urls.txt` with one URL per line:

```
https://www.youtube.com/watch?v=VIDEO_ID_1
https://www.youtube.com/watch?v=VIDEO_ID_2
https://www.youtube.com/playlist?list=PLAYLIST_ID
```

Then run:

```powershell
yt-dlp -x --audio-format mp3 --audio-quality 0 `
  --add-metadata --embed-thumbnail `
  -o "%(title)s.%(ext)s" `
  -a urls.txt
```

---

## Updating yt-dlp

Keep yt-dlp up to date to avoid YouTube breakage:

```powershell
yt-dlp -U
```

Or via winget:

```powershell
winget upgrade yt-dlp.yt-dlp
```

---

## Troubleshooting

| Problem                    | Solution                                   |
| -------------------------- | ------------------------------------------ |
| `yt-dlp` not found         | Restart terminal after install; check PATH |
| `ffmpeg` not found         | Same as above; yt-dlp needs ffmpeg in PATH |
| Download fails / 403 error | Run `yt-dlp -U` to update                  |
| Age-restricted video       | Add `--cookies-from-browser chrome`        |
| Slow download              | Add `--concurrent-fragments 4`             |
| Thumbnail not embedding    | Make sure ffmpeg is installed              |

---

## Example: Full Workflow

```powershell
# 1. Create a music folder
mkdir "C:\Users\andygr1n1\Music\Downloads"

# 2. Download a playlist to that folder
yt-dlp -x --audio-format mp3 --audio-quality 0 `
  --embed-thumbnail --add-metadata --ignore-errors `
  -o "C:\Users\andygr1n1\Music\Downloads\%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" `
  "https://www.youtube.com/playlist?list=YOUR_PLAYLIST_ID"
```

That's it! Your music will be organized in a folder named after the playlist, with numbered tracks and embedded metadata.

---

## Extra: Create a `youtube` Command in PowerShell

If you want to type `youtube <URL>` in terminal and always download only one item, create a small PowerShell function and load it automatically.

### Step 1 — Create a PowerShell profile (if you do not have one)

Open PowerShell and run:

```powershell
if (!(Test-Path -Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force
}
notepad $PROFILE
```

This opens your profile script in Notepad.

### Step 2 — Paste this function into your profile

```powershell
function youtube {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Url
  )

  yt-dlp -x --audio-format mp3 --audio-quality 0 `
    --embed-thumbnail `
    --add-metadata `
    --no-playlist `
    -o "$HOME\Music\%(title)s.%(ext)s" `
    "$Url"
}
```

Save and close Notepad.

### Step 3 — Reload your profile

```powershell
. $PROFILE
```

Now you can run:

```powershell
youtube "https://www.youtube.com/watch?v=VIDEO_ID"
```

### Optional: Use a fixed custom folder

If you prefer a fixed folder, replace the output line with your own path:

```powershell
-o "C:\Users\YourName\Music\%(title)s.%(ext)s" `
```

### Notes

- Use quotes around the URL.
- `--no-playlist` ensures only one item downloads, even if the URL is part of a playlist.
- If PowerShell blocks your profile script, run once:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

## Mac

```
yt-dlp -x --audio-format mp3 --audio-quality 0 \
  --embed-thumbnail \
  --add-metadata \
  --no-playlist \
  -o "~/Downloads/%(title)s.%(ext)s" \
  "https://www.youtube.com/watch?v=r8LJdoxKtcA&list=RDHj2AxxazIsg&index=13"
```
