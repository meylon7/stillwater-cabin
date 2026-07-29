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

| item | model | settings | credits | file |
|---|---|---|---|---|
| Hero loop v1 | `seedance-2` | 5s · 1080p | **338** | `6a69cb28b3e63bc59b9aad1c` | discarded, no motion |
| Hero loop v2 | `seedance-2-fast` | 5s · 720p | **100** | `6a69d608b3e63bc59b9b053f` | shipped |
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

Encoded result: `hero-loop.mp4` at **160 KB** against a 3 MB budget — the motion
is deliberately tiny, so x264 has almost nothing to encode.

---

## Still to generate

- **Hero loop** — Seedance 2.0, `generate_video_from_image` on
  `media/anchors/01_exterior_dock.png`. Prompt in `PROMPTS.md` section 3.
- **7 flight legs** — `generate_first_last_frame`, anchors per `PROMPTS.md`
  section 4. Video bills per second: 7 legs x 5s x the model's cr/s rate.
  Check `list_models type="firstlastgenerations"` and confirm the total before
  firing — this is the expensive half of the project by a wide margin.
