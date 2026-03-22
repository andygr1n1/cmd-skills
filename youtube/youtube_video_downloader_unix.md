# YouTube Video Downloader (1K) — Step-by-Step Guide

A complete guide to downloading YouTube videos and playlists in **1080p (1K)** quality using **yt-dlp** and **ffmpeg** on Unix (macOS / Linux).

---

## Prerequisites

- macOS or Linux
- Terminal (bash or zsh)
- Internet connection

---

## Step 1 — Install yt-dlp

`yt-dlp` is the core tool that handles downloading from YouTube.

### Option A: via Homebrew (macOS, recommended)

```bash
brew install yt-dlp
```

### Option B: via pip (macOS & Linux)

```bash
pip install yt-dlp
```

### Option C: via package manager (Linux)

**Debian / Ubuntu:**
```bash
sudo apt install yt-dlp
```

**Fedora:**
```bash
sudo dnf install yt-dlp
```

**Arch:**
```bash
sudo pacman -S yt-dlp
```

### Option D: Manual download

1. Go to: https://github.com/yt-dlp/yt-dlp/releases/latest
2. Download the appropriate binary (`yt-dlp` for Linux/macOS)
3. Make it executable: `chmod +x yt-dlp`
4. Move it to a folder in your PATH (e.g. `~/.local/bin` or `/usr/local/bin`)

### Verify installation

```bash
yt-dlp --version
```

You should see a version number like `2024.xx.xx`.

---

## Step 2 — Install ffmpeg

`ffmpeg` is required to merge video and audio streams (YouTube often serves them separately for 1080p).

### Option A: via Homebrew (macOS)

```bash
brew install ffmpeg
```

### Option B: via package manager (Linux)

**Debian / Ubuntu:**
```bash
sudo apt install ffmpeg
```

**Fedora:**
```bash
sudo dnf install ffmpeg
```

**Arch:**
```bash
sudo pacman -S ffmpeg
```

### Verify installation

```bash
ffmpeg -version
```

> **Important:** After installing both tools, **restart your terminal** (or run `hash -r`) so PATH changes take effect.

---

## Step 3 — Basic Usage

### Download a single video in 1080p (1K)

```bash
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 "https://www.youtube.com/watch?v=VIDEO_ID"
```

The file will be saved in your **current directory** as MP4.

### Download with a custom output filename

```bash
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 -o "%(title)s.%(ext)s" "URL"
```

---

## Step 4 — Download an Entire Playlist

```bash
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 \
  -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" \
  "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

This will:

- Create a folder named after the playlist
- Number each video in order
- Save each as `01 - Video Title.mp4`, `02 - Video Title.mp4`, etc.

---

## Step 5 — Download to a Specific Folder

Replace the output path with your desired videos folder:

```bash
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 \
  -o "$HOME/Videos/%(title)s.%(ext)s" \
  "URL"
```

---

## Step 6 — Embed Metadata and Thumbnail

For proper video metadata and thumbnail:

```bash
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 \
  --embed-thumbnail \
  --add-metadata \
  --parse-metadata "%(uploader)s:%(meta_artist)s" \
  -o "%(title)s.%(ext)s" \
  "URL"
```

This embeds:

- **Title** — from video title
- **Artist** — from channel/uploader name
- **Thumbnail** — as video thumbnail metadata

---

## Step 7 — Recommended All-in-One Command

This is the best general-purpose command for 1K video downloads:

```bash
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 \
  --embed-thumbnail \
  --add-metadata \
  --no-playlist \
  -o "$HOME/Videos/%(title)s.%(ext)s" \
  "URL"
```

> Use `--no-playlist` when you paste a video URL that belongs to a playlist but you only want that single video.

---

## Flag Reference

| Flag                            | Description                                                |
| ------------------------------- | ---------------------------------------------------------- |
| `-f "..."`                      | Format: best video up to 1080p + best audio                |
| `--merge-output-format mp4`     | Merge video and audio into MP4                              |
| `-o "..."`                      | Output path and filename template                           |
| `--embed-thumbnail`             | Embed thumbnail into the video file                         |
| `--add-metadata`                | Write title, artist, etc. into video tags                   |
| `--no-playlist`                 | Download only the single video, not the full playlist      |
| `--yes-playlist`                | Force download the entire playlist                         |
| `--playlist-start N`            | Start downloading from video number N                      |
| `--playlist-end N`              | Stop downloading at video number N                         |
| `--ignore-errors`               | Skip unavailable videos instead of stopping                |
| `--cookies-from-browser chrome` | Use Chrome cookies (for age-restricted content)             |
| `--cookies-from-browser safari` | Use Safari cookies (macOS alternative)                     |
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

```bash
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 \
  --add-metadata --embed-thumbnail \
  -o "%(title)s.%(ext)s" \
  -a urls.txt
```

---

## Updating yt-dlp

Keep yt-dlp up to date to avoid YouTube breakage:

```bash
yt-dlp -U
```

Or via Homebrew (macOS):
```bash
brew upgrade yt-dlp
```

Or via pip:
```bash
pip install -U yt-dlp
```

---

## Troubleshooting

| Problem                    | Solution                                   |
| -------------------------- | ------------------------------------------ |
| `yt-dlp` not found         | Restart terminal after install; check PATH; ensure `~/.local/bin` is in PATH if using pip |
| `ffmpeg` not found         | Same as above; yt-dlp needs ffmpeg to merge video+audio |
| Download fails / 403 error | Run `yt-dlp -U` to update                  |
| Age-restricted video       | Add `--cookies-from-browser chrome` (or `safari` on macOS) |
| Slow download              | Add `--concurrent-fragments 4`             |
| Thumbnail not embedding    | Make sure ffmpeg is installed              |
| Video has no audio         | Ensure ffmpeg is in PATH for merging       |
| Wrong video downloads      | See below                                  |

### Wrong video downloads

If yt-dlp downloads a different video than the one in your URL:

1. **Add `--no-playlist`** — When the URL includes `&list=...`, yt-dlp may treat it as a playlist and pick a different entry. Force single-video mode:
   ```bash
   yt-dlp --no-playlist -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 "URL"
   ```

2. **Use the canonical URL** — Prefer `https://www.youtube.com/watch?v=VIDEO_ID`. Shortened URLs (`youtu.be/...`) or links with many query params can sometimes resolve incorrectly.

3. **Verify the video ID** — Check what yt-dlp sees before downloading:
   ```bash
   yt-dlp --dump-json "YOUR_URL" | head -1
   ```
   Look at the `id` and `title` fields to confirm it’s the right video.

4. **Use `--force-generic-extractor`** — If the wrong extractor is selected (e.g. for Shorts), forcing generic extraction can help:
   ```bash
   yt-dlp --force-generic-extractor "URL"
   ```

---

## Example: Full Workflow

```bash
# 1. Create a videos folder
mkdir -p "$HOME/Videos/Downloads"

# 2. Download a playlist to that folder
yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 \
  --embed-thumbnail --add-metadata --ignore-errors \
  -o "$HOME/Videos/Downloads/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" \
  "https://www.youtube.com/playlist?list=YOUR_PLAYLIST_ID"
```

That's it! Your videos will be organized in a folder named after the playlist, with numbered files and embedded metadata.

---

## Extra: Create a `youtube` Shell Alias/Function

If you want to type `youtube <URL>` in terminal and always download only one video in 1K, add a shell function to your profile.

### Step 1 — Open your shell config

For **bash** (`~/.bashrc`) or **zsh** (`~/.zshrc`):

```bash
# bash users
nano ~/.bashrc

# or zsh users
nano ~/.zshrc
```

Use any editor you prefer: `nano`, `vim`, `code ~/.zshrc`, etc.

### Step 2 — Add this function

```bash
youtube() {
  if [ -z "$1" ]; then
    echo "Usage: youtube <URL>"
    return 1
  fi
  yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 \
    --embed-thumbnail \
    --add-metadata \
    --no-playlist \
    -o "$HOME/Videos/%(title)s.%(ext)s" \
    "$1"
}
```

Save and close the editor.

### Step 3 — Reload your profile

```bash
# bash
source ~/.bashrc

# or zsh
source ~/.zshrc
```

Now you can run:

```bash
youtube "https://www.youtube.com/watch?v=VIDEO_ID"
```

### Optional: Use a fixed custom folder

If you prefer a fixed folder, replace the output path in the function:

```bash
-o "$HOME/Videos/%(title)s.%(ext)s"
```

### Notes

- Use quotes around the URL.
- `--no-playlist` ensures only one video downloads, even if the URL is part of a playlist.
- On first use, you may need to run `chmod +x ~/.zshrc` (or `~/.bashrc`) if the file had wrong permissions.
