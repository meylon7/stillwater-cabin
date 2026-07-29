#!/usr/bin/env bash
# Stillwater - encode the hero loop.
#
# This is the PLAYBACK encode. The flight uses a different one entirely, and
# the two are not interchangeable - see build-flight.sh for why.
#
#   bash scripts/encode-hero.sh media/raw/hero_raw.mp4

set -euo pipefail

SRC="${1:-media/raw/hero_raw.mp4}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/assets/hero-loop.mp4"
POSTER="$ROOT/assets/hero-poster.jpg"

[ -f "$SRC" ] || { echo "missing source: $SRC" >&2; exit 1; }

# Ping-pong loop: the clip forward, then the clip reversed.
#
# A hero video carries the `loop` attribute, so the last frame is followed
# immediately by the first. Any drift between them shows as a visible pop once
# per cycle. Our clip ends with mist across the water that was not there at the
# start, which is exactly the motion we asked for - and exactly what breaks the
# loop.
#
# Playing it forward then backward makes the join happen on a frame that is
# identical to itself on both sides, so there is no seam to hide. It costs
# double the duration and roughly double the bytes, which at 268 KB against a
# 3 MB budget is not a real cost.
#
# Note the earlier version of this clip looped cleanly only because it was
# almost a still image. One bug was concealing the other.
#
# No upscale. The render behind this is 1024 wide; scaling to 1920 buys bytes,
# not detail. -2 keeps the height even, which libx264 requires.
ffmpeg -y -loglevel error -i "$SRC" \
  -filter_complex "[0:v]scale=1024:-2,fps=30,split[fwd][rev];[rev]reverse,trim=start_frame=1[back];[fwd][back]concat=n=2:v=1:a=0" \
  -c:v libx264 -crf 26 -preset slow \
  -pix_fmt yuv420p -an -movflags +faststart \
  "$OUT"

# The poster is frame 1 of the encoded file, not of the source. If it came from
# the source the first painted frame and the poster would differ slightly and
# the hero would flicker the moment the video takes over.
ffmpeg -y -loglevel error -i "$OUT" -vframes 1 -q:v 2 "$POSTER"

# -pix_fmt yuv420p above is the difference between a working video and a black
# rectangle on Apple devices only. It is the failure that surfaces last,
# because it never appears on the machine you built the site on.

size() { du -k "$1" | cut -f1; }
printf '%-22s %6s KB   (budget 3000)\n' "hero-loop.mp4"   "$(size "$OUT")"
printf '%-22s %6s KB   (budget 200)\n'  "hero-poster.jpg" "$(size "$POSTER")"

[ "$(size "$OUT")" -gt 3000 ] && echo "WARNING: hero loop is over the 3 MB budget" >&2
exit 0
