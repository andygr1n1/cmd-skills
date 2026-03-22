# YouTube Video Downloader (1K) — Step-by-Step Guide

A complete guide to downloading YouTube videos and playlists in **1080p (1K)** quality using **yt-dlp** and **ffmpeg** on Windows.

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

`ffmpeg` is required to merge video and audio streams (YouTube often serves them separately for 1080p).

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

### Download a single video in 1080p (1K)

```powershell
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 "https://www.youtube.com/watch?v=VIDEO_ID"
```

The file will be saved in your **current directory** as MP4.

### Download with a custom output filename

```powershell
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 -o "%(title)s.%(ext)s" "URL"
```

---

## Step 4 — Download an Entire Playlist

```powershell
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 `
  -o "%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" `
  "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

This will:

- Create a folder named after the playlist
- Number each video in order
- Save each as `01 - Video Title.mp4`, `02 - Video Title.mp4`, etc.

---

## Step 5 — Download to a Specific Folder

Replace the output path with your desired videos folder:

```powershell
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 `
  -o "C:\Users\YourName\Videos\%(title)s.%(ext)s" `
  "URL"
```

---

## Step 6 — Embed Metadata and Thumbnail

For proper video metadata and thumbnail:

```powershell
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 `
  --embed-thumbnail `
  --add-metadata `
  --parse-metadata "%(uploader)s:%(meta_artist)s" `
  -o "%(title)s.%(ext)s" `
  "URL"
```

This embeds:

- **Title** — from video title
- **Artist** — from channel/uploader name
- **Thumbnail** — as video thumbnail metadata

---

## Step 7 — Recommended All-in-One Command

This is the best general-purpose command for 1K video downloads:

```powershell
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 `
  --embed-thumbnail `
  --add-metadata `
  --no-playlist `
  -o "C:\Users\andygr1n1\Videos\%(title)s.%(ext)s" `
  "URL"
```

> Use `--no-playlist` when you paste a video URL that belongs to a playlist but you only want that single video.

---

## Flag Reference

| Flag                            | Description                                                |
| ------------------------------- | ---------------------------------------------------------- |
| `-f "..."`                      | Format: best video up to 1080p + best audio                 |
| `--merge-output-format mp4`     | Merge video and audio into MP4                              |
| `-o "..."`                      | Output path and filename template                           |
| `--embed-thumbnail`             | Embed thumbnail into the video file                         |
| `--add-metadata`                | Write title, artist, etc. into video tags                    |
| `--no-playlist`                 | Download only the single video, not the full playlist       |
| `--yes-playlist`                | Force download the entire playlist                          |
| `--playlist-start N`            | Start downloading from video number N                      |
| `--playlist-end N`              | Stop downloading at video number N                          |
| `--ignore-errors`               | Skip unavailable videos instead of stopping                 |
| `--cookies-from-browser chrome` | Use Chrome cookies (for age-restricted content)             |
| `--concurrent-fragments 4`      | Faster downloads for DASH streams                           |

---

## Output Template Variables

Use these placeholders in the `-o` path:

| Variable             | Meaning                  |
| -------------------- | ------------------------ |
| `%(title)s`          | Video title              |
| `%(uploader)s`       | Channel name             |
| `%(playlist)s`       | Playlist name            |
| `%(playlist_index)s` | Track number in playlist |
| `%(ext)s`            | File extension (mp4)     |
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
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 `
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
| `ffmpeg` not found         | Same as above; yt-dlp needs ffmpeg to merge video+audio |
| Download fails / 403 error | Run `yt-dlp -U` to update                  |
| Age-restricted video       | Add `--cookies-from-browser chrome`        |
| Slow download              | Add `--concurrent-fragments 4`             |
| Thumbnail not embedding    | Make sure ffmpeg is installed              |
| Video has no audio         | Ensure ffmpeg is in PATH for merging       |

---

## Example: Full Workflow

```powershell
# 1. Create a videos folder
mkdir "C:\Users\andygr1n1\Videos\Downloads"

# 2. Download a playlist to that folder
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 `
  --embed-thumbnail --add-metadata --ignore-errors `
  -o "C:\Users\andygr1n1\Videos\Downloads\%(playlist)s\%(playlist_index)s - %(title)s.%(ext)s" `
  "https://www.youtube.com/playlist?list=YOUR_PLAYLIST_ID"
```

That's it! Your videos will be organized in a folder named after the playlist, with numbered files and embedded metadata.

---

## Extra: Create a `youtube` Command in PowerShell

If you want to type `youtube <URL>` in terminal and always download only one video in 1K, create a small PowerShell function and load it automatically.

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

  yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 `
    --embed-thumbnail `
    --add-metadata `
    --no-playlist `
    -o "$HOME\Videos\%(title)s.%(ext)s" `
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
-o "C:\Users\YourName\Videos\%(title)s.%(ext)s" `
```

### Notes

- Use quotes around the URL.
- `--no-playlist` ensures only one video downloads, even if the URL is part of a playlist.
- If PowerShell blocks your profile script, run once:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```
