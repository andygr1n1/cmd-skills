# Instagram Reels Downloader — Step-by-Step Guide

A complete guide to downloading **Instagram Reels** (and regular posts) using **yt-dlp** on Unix (macOS / Linux).

---

## Prerequisites

- macOS or Linux
- Terminal (bash or zsh)
- Internet connection

---

## Step 1 — Install yt-dlp

`yt-dlp` is the core tool that handles downloading from Instagram.

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

## Step 2 — Install ffmpeg (recommended)

`ffmpeg` is needed when Instagram serves video and audio separately (DASH format). For single-file Reels it's optional, but recommended.

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

### Supported URLs

- **Reels:** `https://www.instagram.com/reel/ABC123xyz/`
- **Posts (video):** `https://www.instagram.com/p/ABC123xyz/`
- **Share URLs:** `https://www.instagram.com/share/reel/ABC123xyz`

### Download a single Reel (best quality)

```bash
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 "https://www.instagram.com/reel/REEL_ID/"
```

The file will be saved in your **current directory** as MP4.

### Simpler variant (single file when available)

Many Reels are served as one combined file. In that case:

```bash
yt-dlp -f best "https://www.instagram.com/reel/REEL_ID/"
```

### Download with a custom output filename

```bash
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 -o "%(title)s.%(ext)s" "URL"
```

---

## Step 4 — Download to a Specific Folder

```bash
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 \
  -o "$HOME/Videos/Instagram/%(title)s.%(ext)s" \
  "https://www.instagram.com/reel/REEL_ID/"
```

Create the folder first if it doesn't exist:

```bash
mkdir -p "$HOME/Videos/Instagram"
```

---

## Step 5 — Embed Metadata and Thumbnail

For proper video metadata and thumbnail:

```bash
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 \
  --embed-thumbnail \
  --add-metadata \
  -o "%(title)s.%(ext)s" \
  "URL"
```

This embeds:

- **Title** — from caption or description
- **Artist** — from username
- **Thumbnail** — as video thumbnail metadata

---

## Step 6 — Recommended All-in-One Command

Best general-purpose command for Reels:

```bash
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 \
  --embed-thumbnail \
  --add-metadata \
  -o "$HOME/Videos/Instagram/%(uploader)s - %(title)s.%(ext)s" \
  "URL"
```

Reels are typically 1080×1920 (portrait). If the Reel has DASH streams, yt-dlp will merge video and audio automatically.

---

## Flag Reference

| Flag                            | Description                                              |
| ------------------------------- | -------------------------------------------------------- |
| `-f "..."`                      | Format: best video + best audio, or single best file     |
| `--merge-output-format mp4`     | Merge video and audio into MP4 (when separate)           |
| `-o "..."`                      | Output path and filename template                         |
| `--embed-thumbnail`             | Embed thumbnail into the video file                       |
| `--add-metadata`                | Write title, artist, etc. into video tags                 |
| `--cookies-from-browser chrome` | Use Chrome cookies (for private or login-required posts)  |
| `--cookies-from-browser safari` | Use Safari cookies (macOS alternative)                    |
| `-F`                            | List available formats without downloading                |

---

## Output Template Variables

Use these placeholders in the `-o` path:

| Variable             | Meaning                  |
| -------------------- | ------------------------ |
| `%(title)s`          | Caption or description   |
| `%(uploader)s`       | Instagram username       |
| `%(ext)s`            | File extension (mp4)     |
| `%(id)s`             | Instagram media ID       |
| `%(upload_date)s`    | Upload date (YYYYMMDD)   |

---

## Batch Download from a Text File

Create a file called `reels.txt` with one URL per line:

```
https://www.instagram.com/reel/ABC123/
https://www.instagram.com/reel/XYZ789/
https://www.instagram.com/p/DEF456/
```

Then run:

```bash
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 \
  --add-metadata --embed-thumbnail \
  -o "$HOME/Videos/Instagram/%(uploader)s - %(title)s.%(ext)s" \
  -a reels.txt
```

---

## Updating yt-dlp

Instagram changes its API frequently. Keep yt-dlp up to date:

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

| Problem                         | Solution                                                                 |
| ------------------------------- | ------------------------------------------------------------------------ |
| `yt-dlp` not found              | Restart terminal after install; check PATH; ensure `~/.local/bin` in PATH if using pip |
| `ffmpeg` not found              | Same as above; required for merging DASH video+audio                     |
| `No csrf token set by Instagram`| Usually harmless; download often still works. If it fails, try cookies (below) |
| Download fails / Login required | Add `--cookies-from-browser chrome` or `--cookies-from-browser safari`   |
| 403 / 429 errors                | Run `yt-dlp -U` to update; Instagram may have changed something          |
| Private or restricted Reel     | Use `--cookies-from-browser chrome` (log into Instagram in that browser first) |
| Check available formats         | Run `yt-dlp -F "URL"` to see what formats a Reel offers                  |

### Using browser cookies

If a Reel requires login or keeps failing:

1. Log into Instagram in Chrome (or Safari on macOS).
2. Run yt-dlp with cookies:

   ```bash
   yt-dlp --cookies-from-browser chrome -f best "URL"
   ```

   Or for Safari on macOS:

   ```bash
   yt-dlp --cookies-from-browser safari -f best "URL"
   ```

---

## Extra: Create an `instagram` Shell Function

Add a shell function to download Reels with `instagram <URL>`:

### Step 1 — Open your shell config

For **bash** (`~/.bashrc`) or **zsh** (`~/.zshrc`):

```bash
# bash users
nano ~/.bashrc

# or zsh users
nano ~/.zshrc
```

### Step 2 — Add this function

```bash
instagram() {
  if [ -z "$1" ]; then
    echo "Usage: instagram <REEL_URL>"
    return 1
  fi
  yt-dlp --cookies-from-browser chrome \
    -f "bestvideo+bestaudio/best" --merge-output-format mp4 \
    --embed-thumbnail \
    --add-metadata \
    -o "$HOME/Videos/Instagram/%(uploader)s - %(title)s.%(ext)s" \
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
instagram "https://www.instagram.com/reel/ABC123/"
```

### Notes

- Use quotes around the URL.
- The output folder `~/Videos/Instagram` is created automatically if you've used it before; otherwise run `mkdir -p ~/Videos/Instagram` once.
- Uses Chrome cookies by default (Instagram often requires login). Log into Instagram in Chrome first. On macOS you can switch to `safari` if needed.
- If cookie extraction fails, quit Chrome and retry.
