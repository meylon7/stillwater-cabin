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

## Still to generate

- **Hero loop** — Seedance 2.0, `generate_video_from_image` on
  `media/anchors/01_exterior_dock.png`. Prompt in `PROMPTS.md` section 3.
- **7 flight legs** — `generate_first_last_frame`, anchors per `PROMPTS.md`
  section 4. Video bills per second: 7 legs x 5s x the model's cr/s rate.
  Check `list_models type="firstlastgenerations"` and confirm the total before
  firing — this is the expensive half of the project by a wide margin.
