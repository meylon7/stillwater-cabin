#!/usr/bin/env python3
"""Static dev server that supports HTTP Range requests.

Why this file exists instead of `python -m http.server`:

The scroll-scrub technique is nothing but repeated assignment to
`video.currentTime`. A browser will only honour that if it can fetch arbitrary
byte ranges of the media file, which means the server has to answer
`Range: bytes=...` with `206 Partial Content`.

Python's stdlib SimpleHTTPRequestHandler does not. It ignores the Range header
and returns the whole file with `200`. Chrome then marks the resource as not
seekable: `video.seekable.end(0)` reads 0, every `currentTime` assignment
clamps back to 0, and the flight is frozen on frame one.

The cruel part is the symptom. `readyState` reaches 4, `duration` reads
correctly, no error fires, and the progress rail tracks the scroll perfectly -
so it looks exactly like a bug in your JavaScript. It is not. It is the server.

Every real static host (nginx, Vercel, Netlify, GitHub Pages, S3, Cloudflare)
supports Range out of the box, so this only ever bites in local development.

    python scripts/serve.py           # http://localhost:8080
    python scripts/serve.py 3000
"""

import os
import re
import sys
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

RANGE_RE = re.compile(r"bytes=(\d*)-(\d*)")


class RangeHandler(SimpleHTTPRequestHandler):
    def send_head(self):
        header = self.headers.get("Range")
        if not header:
            return super().send_head()

        path = self.translate_path(self.path)
        if os.path.isdir(path):
            return super().send_head()

        match = RANGE_RE.fullmatch(header.strip())
        if not match:
            return super().send_head()

        try:
            handle = open(path, "rb")
        except OSError:
            self.send_error(404)
            return None

        size = os.fstat(handle.fileno()).st_size
        start_raw, end_raw = match.groups()

        if start_raw:
            start = int(start_raw)
            end = int(end_raw) if end_raw else size - 1
        else:
            # suffix form, "bytes=-500" means the last 500 bytes
            start = max(0, size - int(end_raw))
            end = size - 1

        if start >= size:
            handle.close()
            self.send_response(416)
            self.send_header("Content-Range", "bytes */%d" % size)
            self.end_headers()
            return None

        end = min(end, size - 1)
        handle.seek(start)

        self.send_response(206)
        self.send_header("Content-Type", self.guess_type(path))
        self.send_header("Content-Range", "bytes %d-%d/%d" % (start, end, size))
        self.send_header("Content-Length", str(end - start + 1))
        self.send_header("Accept-Ranges", "bytes")
        self.end_headers()
        return _Window(handle, end - start + 1)

    def end_headers(self):
        # Advertise Range support on every response, and keep the browser from
        # caching a stale build while you iterate.
        self.send_header("Accept-Ranges", "bytes")
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def log_message(self, fmt, *args):
        if "200" not in fmt % args and "206" not in fmt % args:
            super().log_message(fmt, *args)


class _Window:
    """Reads at most `remaining` bytes, so copyfile stops at the range end."""

    def __init__(self, handle, remaining):
        self.handle = handle
        self.remaining = remaining

    def read(self, amount=-1):
        if self.remaining <= 0:
            return b""
        if amount < 0 or amount > self.remaining:
            amount = self.remaining
        chunk = self.handle.read(amount)
        self.remaining -= len(chunk)
        return chunk

    def close(self):
        self.handle.close()


if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    handler = partial(RangeHandler, directory=root)
    print("Serving %s on http://localhost:%d  (Range requests enabled)" % (root, port))
    ThreadingHTTPServer(("", port), handler).serve_forever()
