# Stillwater — production log

Project: `Stillwater — Cabin Site & Scroll Flight`
`project_id: 6a69bf2cb3e63bc59b9a4f45`
<https://app.kolbo.ai/media?project=6a69bf2cb3e63bc59b9a4f45>

Every generation call must carry that `project_id`. It is per-call, not sticky.

---

## Renders 01-10 — 2026-07-29

Model `gpt-image-2` · 1K · quality medium · aspect 3:2 · `enhance_prompt: false`
Delivered at **1024x688** — that is the real 1K tier output, not the 1536x1024 the
3:2 label suggests. The manifest records the real number.

Two full passes were run. **160 credits total**, 20 of 20 completed, 0 failed.

### v2 — the shipped set. Anchor carries massing AND materials

| shot | generation_id | file |
|---|---|---|
| 01 exterior from the dock | `6a69c20712e5571280ee1f5c` | `01_exterior_dock` |
| 02 deck through the glass | `6a69c20ab3e63bc59b9a686f` | `02_deck_through_glass` |
| 03 great room | `6a69c20f6a0cdce83d08899b` | `03_great_room` |
| 04 fireplace | `6a69c2136a0cdce83d0889a3` | `04_fireplace` |
| 05 kitchen | `6a69c2185d29166559760506` | `05_kitchen` |
| 06 dining nook | `6a69c21d5d29166559760525` | `06_dining` |
| 07 primary bedroom | `6a69c2205d29166559760540` | `07_primary_bedroom` |
| 08 stone bath | `6a69c22412e5571280ee2059` | `08_stone_bath` |
| 09 sauna | `6a69c2285d29166559760570` | `09_sauna` |
| 10 dock at dusk | `6a69c22c6a0cdce83d088a17` | `10_dock_dusk` |

### v1 — discarded. Anchor carried materials only

`6a69bfb06a0cdce83d087576` `6a69bfbb12e5571280ee0b49` `6a69bfc05d2916655975f198`
`6a69bfc4b3e63bc59b9a54e9` `6a69bfc75d2916655975f1f1` `6a69bfcb6a0cdce83d0876d9`
`6a69bfceb3e63bc59b9a555f` `6a69bfd6b3e63bc59b9a55a0` `6a69bfda12e5571280ee0c9a`
`6a69bfdd5d2916655975f2ab`

Kept in `media/anchors/v1-materials-anchor/` as classroom material. The failure is
worth showing: the materials held perfectly across all ten and the **building**
drifted — 01 came back two storey at the waterline, 02 as a single storey deck,
10 on a wooded bluff. Three houses, one palette. See the anchor section in
`PROMPTS.md` for why, and why the fix meant re-running all ten rather than
patching the two outliers.

Pull the shipped set down with `pwsh scripts/fetch-renders.ps1` — it writes the
untouched PNG to `media/anchors/` and the graded, compressed JPG to `assets/`.

---

## Three things the lesson does not tell you about running this on Kolbo

**1. `enhance_prompt` defaults to true, and it silently rewrites the anchor.**
The entire method rests on one paragraph arriving at the model byte-identical
ten times. Prompt enhancement rewrites it per call, so the ten renders are no
longer anchored to the same text and consistency collapses. Every call here
sends `enhance_prompt: false`. Without that flag the lesson does not work,
and the failure looks like "the model is inconsistent" rather than
"the platform edited my prompt".

**2. All eight flight anchors must share one aspect ratio.**
The plan was 3:2 for exteriors and 4:3 for interiors. A flight leg interpolates
between two anchors, so a leg whose first and last frames have different shapes
has nothing sane to render. Every render is 3:2.

**3. Quote the real cost, never the estimate.**
`credits_used` came back on each generation. 8 x 10 = 80. Do not compute a
remaining balance by subtraction — chat and coding spend credits too, so the
arithmetic is stale the moment you write it. Run `check_credits` fresh instead.

---

## Video — 2026-07-29

| item | model | settings | credits | generation | note |
|---|---|---|---|---|---|
| Hero loop v1 | `seedance-2` | 5s · 1080p | **338** | `6a69cb28b3e63bc59b9aad1c` | discarded, no motion |
| Hero loop v2 | `seedance-2-fast` | 5s · 720p | **100** | `6a69d608b3e63bc59b9b053f` | discarded, motion still too subtle |
| Hero loop v3 | `seedance-2-fast` | 5s · 720p | **100** | `6a69dd0312e5571280eee1e9` | shipped, slow dolly |
| Legs 1-7 | `dop/standard/first-last-frame` | 5s · 720p each | **700** | 7 generations | 2 extra 400s, not charged |

Both completed. Video bills per second, so the `duration_multiplier: 5` in the
breakdown is the whole story: Seedance is roughly 68 cr/s, Higgsfield DoP
roughly 20 cr/s. **Seedance costs 3.4x per second for a clip that barely moves.**

### Three findings from the pilot

**1. The seam law holds, and it is verifiable.** The last frame of leg 1 and
anchor 02 are the same image — same sofa, same ridge line, same reflection on
the deck boards. Extract both and stack them before paying for six more legs:

```bash
ffmpeg -sseof -0.1 -i media/legs/leg_1.mp4 -vframes 1 last.png
```

**2. `aspect_ratio` in the response metadata lies. Measure the file.**
Both generations report `"aspect_ratio": "16:9"`. The actual files:

- `leg_1.mp4` → **1168x784**, which is 3:2. The first/last frame model inferred
  the ratio from the anchors and kept it, exactly as wanted.
- `hero_raw.mp4` → **1920x1080**, genuinely 16:9. Seedance ignored the 3:2 input
  and cropped in. The cabin sits noticeably larger in frame than in anchor 01.

Never trust the reported ratio. `ffprobe` the file.

**3. The hero poster must come from the encoded video, not from the anchor.**
Because Seedance re-cropped, a poster cut from anchor 01 no longer matches the
first painted frame, and the hero visibly jumps the moment the video takes over.
`scripts/encode-hero.sh` takes the poster from frame 1 of `hero-loop.mp4`, which
makes the mismatch impossible by construction. The crop stops mattering.

**4. Two more findings from the full run of seven legs.**

*Concurrency.* Six legs fired at once; the last two came back `400`. That is not
a bad request, it is the video concurrency ceiling — roughly 3 to 5 in flight,
against about 10 for images — reported as an input error. The symptom sends you
to check the anchor URLs instead of the rate. Failures were not charged.

*The CDN served wrong objects for correct URLs.* Two legs downloaded as byte
duplicates of two others. Nothing downstream would have caught it: `concat`
stitches whatever order it is handed and the flight simply teleports mid-move.
Adding `Cache-Control: no-cache` to the request fixed the fetch, but the real
answer is to stop trusting file names. `scripts/identify-legs.ps1` matches every
clip's first and last frame against all ten anchors — same image scores 1.1-3.9,
a different room scores 40+, so the verdict is arithmetic rather than judgement.
It also doubles as the proof that the seam law held across all seven joints.

---

## The hero, twice

**v1 was a 338-credit still image.** The prompt carried four negations and one
positive word, `subtle`. The model obeyed all of it, including the part we did
not mean. Frame drift over five seconds: **1.77 out of 255**.

The lesson's own rule — short prompts win with video models — is right about
*camera* motion and wrong about *world* motion. Negations restrain the camera;
only concrete verbs with a quantity move anything.

**v2 shipped.** One negation for the camera, then verbs: mist crossing a third
of the frame in five seconds, continuous ripple, branches swaying, interior
lights flickering. Drift: **5.99**. Cost **100** on `seedance-2-fast` at 720p
against 338 on `seedance-2` at 1080p — 20 cr/s versus 68 — for a clip whose
entire content is drifting mist.

**And that fix exposed a bug the broken version had been hiding.** A hero
carries `loop`, so the last frame is followed immediately by the first. Real
motion means they no longer match, and there is a visible pop every cycle. v1
looped cleanly only because there was nothing to see.

The fix belongs in the encode, not the prompt: play the clip forward, then
reversed. The join then lands on a frame identical to itself on both sides.
`trim=start_frame=1` on the reversed half is required — without it the shared
frame plays twice and the motion stalls, the same reasoning as dropping the
duplicated frame at each flight seam.

```text
loop seam  first vs last : 5.99 -> 1.76    down to the compression noise floor
peak motion first vs mid : 6.11            motion fully preserved
```

Two apparently opposed goals, both met, both measured. 528 KB against a 3 MB
budget.

---

## Totals

| | credits |
|---|---|
| 20 renders, two anchor passes | 160 |
| Hero v1, discarded | 338 |
| Hero v2, discarded | 100 |
| Hero v3, shipped | 100 |
| 7 flight legs | 700 |
| **Total** | **1,398** |

Two `400` failures were not charged. Do not compute a remaining balance by
subtraction — chat and coding spend credits too. Run `check_credits` fresh.
