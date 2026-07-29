#!/usr/bin/env bash
# Stillwater - stitch the seven legs into one scroll-scrubbable flight.
#
# Reads  media/legs/leg_1.mp4 .. leg_7.mp4
# Writes assets/flight_desktop.mp4, assets/flight_mobile.mp4, assets/flight_poster.jpg
#
#   bash scripts/build-flight.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LEGS="$ROOT/media/legs"
WORK="$ROOT/media/legs/.work"
ASSETS="$ROOT/assets"
mkdir -p "$WORK"

# ---------------------------------------------------------------------------
# 1. Drop the duplicated seam frame
#
# The last frame of leg N is the SAME IMAGE as the first frame of leg N+1 -
# that is the whole point of the seam law. Concatenated as-is, every joint
# shows that image twice and the flight stutters seven times.
# ---------------------------------------------------------------------------
echo "Trimming seam frames:"
for i in 1 2 3 4 5 6 7; do
  f="$LEGS/leg_$i.mp4"
  [ -f "$f" ] || { echo "  missing $f" >&2; exit 1; }

  n=$(ffprobe -v error -select_streams v:0 -count_frames \
        -show_entries stream=nb_read_frames -of csv=p=0 "$f")

  ffmpeg -y -loglevel error -i "$f" \
    -vf "select='not(eq(n\,$((n - 1))))'" -vsync vfr -an \
    "$WORK/trimmed_leg_$i.mp4"

  printf '  leg_%d  %s frames -> %s\n' "$i" "$n" "$((n - 1))"
done

# ---------------------------------------------------------------------------
# 2. Concat
# ---------------------------------------------------------------------------
# Bare file names, not absolute paths. The concat demuxer resolves entries
# relative to the list file, and an absolute POSIX path from Git Bash reaches
# a Windows ffmpeg as "E:/e/..." and fails to open.
: > "$WORK/list.txt"
for i in 1 2 3 4 5 6 7; do
  printf "file 'trimmed_leg_%d.mp4'\n" "$i" >> "$WORK/list.txt"
done

ffmpeg -y -loglevel error -f concat -safe 0 -i "$WORK/list.txt" \
  -c copy "$WORK/flight_raw.mp4"

DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$WORK/flight_raw.mp4")
printf 'Flight length: %.1f s\n' "$DUR"

# ---------------------------------------------------------------------------
# 3. The scrub encode
#
# keyint=5 is the single most important flag in this project.
#
# Ordinary video places a keyframe every ~250 frames. To land on frame 137 the
# browser must decode forward from the keyframe before it. During playback that
# is invisible. During a scroll scrub it is visible as stepping, because the
# decoder is asked for a new position dozens of times a second.
#
# A keyframe every 5 frames removes the stepping and inflates the file 2-3x.
# That inflation is why the desktop tier is not larger: the budget goes into
# keyframes, not pixels.
#
# -tune fastdecode drops encoder tools that make decoding expensive. Same
# reason: this file is decoded far more often than it is played.
# ---------------------------------------------------------------------------
scrub() {
  local width="$1" fps="$2" crf="$3" out="$4"
  ffmpeg -y -loglevel error -i "$WORK/flight_raw.mp4" \
    -vf "scale=$width:-2,fps=$fps" \
    -c:v libx264 -crf "$crf" -preset slow -pix_fmt yuv420p \
    -x264-params "keyint=5:min-keyint=5:scenecut=0" \
    -tune fastdecode -an -movflags +faststart \
    "$ASSETS/$out"
  printf '  %-22s %6s KB\n' "$out" "$(du -k "$ASSETS/$out" | cut -f1)"
}

echo "Scrub encodes:"
scrub 1024 30 24 flight_desktop.mp4
scrub  768 24 26 flight_mobile.mp4

# The poster is frame 1 of the desktop file, which is anchor 01 - the same
# image the hero already shows. A fallback that matches the page it replaces.
ffmpeg -y -loglevel error -i "$ASSETS/flight_desktop.mp4" \
  -vframes 1 -q:v 2 "$ASSETS/flight_poster.jpg"
printf '  %-22s %6s KB\n' "flight_poster.jpg" "$(du -k "$ASSETS/flight_poster.jpg" | cut -f1)"

# ---------------------------------------------------------------------------
# 4. Verify the keyframe interval actually landed
#
# A silent failure here looks exactly like "scroll feels janky on some
# machines", which is the hardest kind of bug to chase later.
# ---------------------------------------------------------------------------
# Pure shell arithmetic, no bc: Git Bash does not ship it, and a missing
# dependency here silently skips the one check that matters.
KEYS=$(ffprobe -v error -select_streams v:0 -show_entries frame=key_frame \
         -of csv=p=0 -read_intervals '%+#40' "$ASSETS/flight_desktop.mp4" \
       | grep -n '^1$' | cut -d: -f1)

FIRST=$(echo "$KEYS" | sed -n '1p')
SECOND=$(echo "$KEYS" | sed -n '2p')
COUNT=$(echo "$KEYS" | grep -c .)

if [ -n "$SECOND" ]; then
  GAP=$((SECOND - FIRST))
  if [ "$GAP" -le 5 ] && [ "$GAP" -gt 0 ]; then
    echo "Keyframes: every $GAP frames, $COUNT in the first 40  OK"
  else
    echo "WARNING: keyframe gap is $GAP, expected 5. Scrubbing will step." >&2
  fi
else
  echo "WARNING: fewer than two keyframes in the first 40 frames. keyint did not apply." >&2
fi

echo
echo "A 35 s flight at 1024 with keyint=5 lands around 6-10 MB. That is well"
echo "over any sane hero budget, and that is fine - it is a different kind of"
echo "asset. What is not fine is shipping it to a phone on cellular, which is"
echo "why flight_mobile.mp4 and the saveData fallback both exist."
