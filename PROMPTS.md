# Stillwater — כל הפרומפטים במקום אחד

הקובץ הזה הוא הנכס. הוא נכתב לפני שקיים קובץ מדיה אחד, כדי ששמות הקבצים לא יסחפו.
ראה `assets/manifest.json` לשמות המדויקים.

---

## 1. פסקת העוגן — נדבקת מילה במילה בכל אחת מ-10 הקריאות

**אל תשנה בה מילה אחת בין רנדר לרנדר.** עקביות היא לא תוצאה של פרומפט טוב,
היא תוצאה של פסקה זהה. אם הספה משנה גוון בין שוט 3 לשוט 7, הטיסה נשברת
ואי אפשר לתקן את זה בעריכה.

```text
A modern two storey lakefront cabin in the Washington Cascades. Flat
cantilevered roof with a deep overhang, blackened steel frame, warm vertical
cedar cladding, floor to ceiling glass on every elevation. The cabin sits low on
a dark stone plinth right at the water's edge, with a timber dock reaching out
in front of it and dense fir forest close behind. Interior palette: sage green
upholstery, soapstone counters, pale oak floors, brushed brass fixtures.
Overcast morning light, low mist on the water, no direct sun. Photographic,
architectural digest style, 35mm, natural color, no people.
```

### למה הפסקה נראית ככה — v1 מול v2

v1 תיארה **חומרים בלבד**: פלדה, ארז, זכוכית, אבן סבון, אורן בהיר.
הרצנו איתה עשרה רנדרים. החומרים נשמרו מושלם, והבניין נסחף: שוט 01 החזיר בית
דו קומתי על שפת המים, שוט 02 מרפסת של מבנה חד קומתי, שוט 10 בית על צוק מיוער.

המודל ממלא כל מה שלא אמרת. v1 לא אמרה מילה על מסה, גובה, צורת גג או יחס למים,
ולכן הוא המציא אותם מחדש בכל קריאה. v2 מוסיפה בדיוק את זה — ולא כלום מעבר.

**עוגן מתאר את מה שאסור שישתנה, לא את מה שיפה לתאר.**
הרנדרים של v1 שמורים ב-`media/anchors/v1-materials-anchor/` להשוואה בכיתה.

---

## 2. עשרת השוטים

מודל: GPT Image 2. הפורמט בכל קריאה: פסקת העוגן, שורה ריקה, ואז שורת ה-SHOT בלבד.

> **חובה: `enhance_prompt: false`.**
> ברירת המחדל של Kolbo היא לשכתב את הפרומפט לפני השליחה. שכתוב פירושו שהעוגן
> כבר לא זהה בין קריאה לקריאה, וכל השיטה קורסת. התסמין נראה כמו "המודל לא עקבי",
> והסיבה האמיתית היא שהפלטפורמה ערכה לך את הטקסט.
>
> **וכל שמונה העוגנים באותו יחס גובה-רוחב.** רגל טיסה מאינטרפולציה בין שני
> עוגנים; שני פריימים בצורות שונות לא נותנים לה מה לרנדר. הכול 3:2.

| # | קובץ | שורת ה-SHOT | תפקיד באתר |
|---|---|---|---|
| 01 | `01_exterior_dock.jpg` | `SHOT 01: exterior, three quarter view from the dock, the whole cabin in frame, lake in the foreground.` | הירו וגלריה |
| 02 | `02_deck_through_glass.jpg` | `SHOT 02: the deck, camera outside looking inward through the floor to ceiling glass into the great room.` | מעבר, גלריה |
| 03 | `03_great_room.jpg` | `SHOT 03: the great room interior, sage green sofa facing the glass wall, lake visible beyond.` | The Spaces |
| 04 | `04_fireplace.jpg` | `SHOT 04: the blackened steel fireplace and hearth, stacked cedar beside it.` | Amenities |
| 05 | `05_kitchen.jpg` | `SHOT 05: the kitchen, soapstone island in the centre, brushed brass fixtures, pale oak floor.` | The Spaces |
| 06 | `06_dining.jpg` | `SHOT 06: the dining nook, pale oak table, window seat looking out to the mist.` | גלריה |
| 07 | `07_primary_bedroom.jpg` | `SHOT 07: the primary bedroom, linen bedding, glass wall to the water.` | The Spaces |
| 08 | `08_stone_bath.jpg` | `SHOT 08: the bath, stone soaking tub against a cedar wall, mist outside the window.` | The Spaces |
| 09 | `09_sauna.jpg` | `SHOT 09: the cedar sauna, low bench, one small window facing the lake.` | Amenities |
| 10 | `10_dock_dusk.jpg` | `SHOT 10: the dock at dusk, cedar canoe tied off, warm lamp glow from the cabin behind.` | סגירה |

**חוקי פסילה**
- כל רנדר שבו חומר משתנה — נפסל ומורץ מחדש. לא "כמעט אותה ספה". אותה ספה.
- אין בני אדם באף רנדר. בני אדם לא נשמרים בין רנדרים והטיסה חושפת את זה מיידית.
- שומרים ברזולוציה מלאה ל-`media/anchors/`. הגרסה שנדחסה לאתר יושבת ב-`assets/`.
  הטיסה משתמשת במקור, לא בדחוס.

`11_host.jpg` הוא לא רנדר. זו תמונה אמיתית של המארחים או פלייסהולדר מוצהר.

---

## 3. וידאו ההירו

מודל: Seedance 2.0. קלט: `media/anchors/01_exterior_dock.jpg`.
פרומפט קצר מנצח. מודלי וידאו מוסיפים תנועה בנדיבות, וכל סעיף נוסף הוא עוד משהו להילחם בו.

```
Animate this image. No zoom in, no zoom out, no camera move.
Subtle looping motion only: mist drifting right to left, small ripples on the
water, leaves moving slightly. Everything else stays still.
```

קידוד: `scripts/encode-hero.sh` (שלב 6).

---

## 4. שבע רגלי הטיסה — חוק התפר

שמונה עוגנים, שבע רגליים. הפריים האחרון של רגל N הוא **בדיוק אותה תמונה**
כמו הפריים הראשון של רגל N+1. לא דומה. אותה תמונה. לכן החיבור בין הקטעים
אינו חיתוך אלא רצף, והחדרים בסרטון הם אותם חדרים שבדף.

| רגל | First frame | Last frame | קובץ פלט |
|---|---|---|---|
| 1 | `01_exterior_dock.jpg` | `02_deck_through_glass.jpg` | `media/legs/leg_1.mp4` |
| 2 | `02_deck_through_glass.jpg` | `03_great_room.jpg` | `media/legs/leg_2.mp4` |
| 3 | `03_great_room.jpg` | `05_kitchen.jpg` | `media/legs/leg_3.mp4` |
| 4 | `05_kitchen.jpg` | `04_fireplace.jpg` | `media/legs/leg_4.mp4` |
| 5 | `04_fireplace.jpg` | `07_primary_bedroom.jpg` | `media/legs/leg_5.mp4` |
| 6 | `07_primary_bedroom.jpg` | `08_stone_bath.jpg` | `media/legs/leg_6.mp4` |
| 7 | `08_stone_bath.jpg` | `10_dock_dusk.jpg` | `media/legs/leg_7.mp4` |

פרומפט זהה לכל רגל, רק העוגנים מתחלפים:

```
First frame: [anchor_A.jpg]
Last frame:  [anchor_B.jpg]

One continuous camera move between them. Slow, steady, cinematic dolly.
No cuts, no zoom snaps, no shutter effects. Keep the exact materials, colors
and furniture from both frames. Overcast daylight throughout.
Duration: 5s.
```

7 רגליים × 5 שניות = 35 שניות טיסה. אחרי הסרת הפריים הכפול בכל תפר: 34.8 שניות.
גובה סקשן 700vh ≈ 20vh לשנייה.

---

## 5. הפרומפט של האתר

הפרומפט המלא לבניית `index.html` נמצא בשיעור, `stillwater_flight_lesson.md` שלב 2.
הוא לא משוכפל כאן כדי שלא יהיו שתי גרסאות שנפרדות זו מזו.

**מה שכן חשוב לזכור ממנו**
- המספרים הם עוגנים: 540, 214, 4.9, 180 ft, 6 sleeps, 180$ ניקיון, 2 לילות מינימום.
- שמות הקבצים נקבעו לפני שהקבצים קיימים.
- החוקים בסוף הפרומפט, לא בהתחלה.
- "self contained" הוא ויתור מודע: קל לתלמידים, חוב טכני אמיתי.
