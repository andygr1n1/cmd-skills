# Facebook Video Downloader

Download a public Facebook video or Reel as MP4 with **yt-dlp** and **ffmpeg**.

The script is `facebook/fb`. Files land in `~/Videos/Facebook/`.

## Prerequisites

`yt-dlp` and `ffmpeg` on `PATH`. On this machine they live in `~/.local/bin`.

```bash
yt-dlp --version
ffmpeg -version
```

## Usage

```bash
chmod +x facebook/fb
facebook/fb "https://www.facebook.com/reel/1835273103828878"
```

Link it so `fb` works from any directory:

```bash
ln -sfn "$HOME/projects/cmd-skills/facebook/fb" "$HOME/.local/bin/fb"
fb "https://www.facebook.com/reel/1835273103828878"
```

Supported hosts: `facebook.com`, `fb.com`, `fb.watch` (videos, Reels, and watch links).

## Login-only videos

If yt-dlp says the video requires login, pass cookies from a browser where you are signed in to Facebook:

```bash
fb --cookies=chrome "https://www.facebook.com/reel/REEL_ID"
```

`chrome`, `firefox`, `chromium`, and `edge` are typical browser names. Quit the browser first if cookie extraction fails.
