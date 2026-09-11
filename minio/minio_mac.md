Create `/Volumes/minio` once at boot (see [README.md](README.md)); no need to `sudo mkdir` each time.

```
sudo /usr/local/bin/rclone mount kzminio: /Volumes/minio \
  --vfs-cache-mode full \
  --allow-other \
  --uid $(id -u) \
  --gid $(id -g)
``` 

```
cd /Volumes/minio && open .
```