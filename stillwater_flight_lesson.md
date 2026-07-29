# מ אפס לטיסה: לבנות את Stillwater ולהפוך אותו לסקרול קולנועי

שיעור מעשי, צעד אחר צעד. התוצאה: אתר בית נופש עם וידאו הירו, ואז אותו בית עצמו כטיסת מצלמה רציפה שהגלילה מניעה.

---

## לפני שמתחילים: שלוש הבהרות

**1. הפרומפטים כאן נכתבו מחדש, לא הועתקו.**
עמוד ה case study המקורי מרנדר את התוכן ב client side. הפרומפטים יושבים ב `{{ promptText }}` ולא קיימים ב HTML הגולמי. לכן הפרומפטים למטה נבנו מהנדסה לאחור של התוצר הסופי, שאותו כן קראתי במלואו. הם מכוונים לשחזר את אותו אתר בדיוק, כולל הקופי והמספרים.

**2. השיעור מתפצל לשני קהלים.**
מסלול א רץ כולו באפליקציה, בלי טרמינל. מסלול ב מחייב Claude Code ו ffmpeg. אם הקהל הוא תלמידי אפליקציה, מסלול ב הוא הדגמה חיה שלך ולא תרגיל שלהם.

**3. יש כאן עלות כספית.**
כל תמונה וכל רגל של הטיסה נצרכות מקרדיטים ב Higgsfield. בלי יתרה, הפריסה תיבנה וכל הפריימים ייכשלו. תגיד את זה לתלמידים בשקף הראשון, לא בשקף האחרון.

---

# מסלול א: האתר

## שלב 1: לנעול רפרנס לפני שכותבים מילה

הקונספט המקורי: **Stayava NatureNook** ב Behance. משם נלקחו שלושה דברים בלבד: מבנה ההירו, זוג הפונטים, והפלטה.

**דגש**
תן לכל רפרנס תפקיד יחיד: אחד ל layout, אחד ל style, אחד ל element. מודלים של תמונה ממזגים כל מה שנותנים להם, ושני רפרנסים עם תפקידים חופפים מחזירים דייסה. התלמיד יקרא את זה כ"המודל גרוע" במקום "הבריף מעורפל".

**דגש משפטי**
בניית דמו פומבי על קונספט של מעצב אחר היא אזור אפור גם עם קרדיט. בקורס תגיד את זה במפורש, ותן לתלמידים רפרנס נייטרלי לתרגיל.

נעל את הפלטה כטוקנים לפני שיש שורת HTML אחת:

```css
:root {
  --ink:      #14201d;
  --teal:     #2f5d55;
  --teal-dim: #4a7a70;
  --amber:    #c98f4b;
  --sand:     #f3ede3;
  --paper:    #fbf8f3;
  --ink-deep: #0c1513;   /* אחד מתחת ל ink, לכל כרום שצף על התמונות */
  --font: "Heebo", system-ui, sans-serif;
}
```

**דגש: משפחה אחת, לא שתיים**

הגרסה הראשונה רצה עם זוג פונטים, Cormorant Garamond לכותרות ו Inter לגוף.
זה נראה טוב וזה גם מייצר שתי מערכות שנסחפות זו מזו, ובעברית זה נשבר לגמרי
כי לרוב זוגות ה display הלטיניים אין בכלל גרסה עברית.

Heebo נושא לטינית ועברית באותו עיצוב, ולכן כל הדף מדבר בקול אחד.
המחיר: ההיררכיה כבר לא מגיעה בחינם מהניגוד serif מול sans, וצריך לייצר אותה.
הכלל שעובד: **ככל שהטיפוגרפיה גדולה יותר, המשקל קל יותר והמרווח בין האותיות
צר יותר.** h1 ב 200 עם `letter-spacing: -0.03em`, גוף ב 400 עם מרווח רגיל.
משקל 200 בגודל 5rem נקרא מכוון; אותו משקל בגודל 1rem נקרא שבור.

---

## שלב 2: הפרומפט האחד

זה הלב של מסלול א. פרומפט אחד, בלי הלוך ושוב.

**דגש על אמינות**
הכותרת "one prompt, one shot" נכונה טכנית ומטעה חינוכית. הפרומפט הזה הוא תוצר של עשרות סבבים שנדחסו לטקסט אחד. תמכור לתלמידים את הגרסה הנכונה: לא "המודל עשה את זה בניסיון אחד" אלא "מישהו שילם את מחיר הסבבים ואתה מקבל את התוצאה מוכנה". זה גם ישר וגם שווה יותר.

```
Build a complete, single file marketing site for a modern lakefront cabin
rental called Stillwater. Output one self contained index.html with all CSS in a
style tag and all interactivity in vanilla JS. No frameworks, no build step.

BRAND
Name: Stillwater. Tagline: "Where the evening slows down."
Positioning: a modern cabin for slow, unplugged stays on a quiet lake in the
Washington Cascades. Warm timber, blackened steel, glass that pulls the lake
indoors.
Voice: quiet, concrete, first person plural from the hosts. Never salesy,
never exclamation marks.

DESIGN TOKENS (use exactly, define as CSS custom properties, no magic numbers)
--ink #14201d, --teal #2f5d55, --teal-dim #4a7a70, --amber #c98f4b,
--sand #f3ede3, --paper #fbf8f3, --ink-deep #0c1513
One typeface for the whole system: Heebo from Google Fonts, weights 200 to 500.
Hierarchy comes from weight and tracking, not from mixing families. Display
sizes run weight 200 with letter-spacing -0.03em; body runs 400 at normal
tracking.
Amber is punctuation, never a surface. It appears as the home glyph in the
wordmark, as a 6px dot before every section eyebrow, on star ratings, on the
checkmarks in the rates list, and on the one amber CTA in the rates card.
Corner radii are generous: 26px on cards and media, full pill on buttons.

LIGHT AND DARK
The page alternates. Content sections sit on --paper or --sand. Chrome and
anything that floats ON a photograph sits on --ink-deep: the header, the
booking card, the amenities band, the reviews band, the rates calculator, the
footer. A pale card over a dark photograph reads as a sticker bolted on top;
a card darker than the frame reads as part of it.
Primary buttons follow the surface: cream --paper pill on dark, --ink-deep
pill on light, amber reserved for the single rates CTA.

STRUCTURE, in this order
1. Fixed header, dark at all times: a small amber home glyph plus the wordmark
   in body weight 500 on the left, nav (The Spaces, Amenities, Gallery,
   Reviews, The Host), cream "Check availability" pill on the right.
   Translucent --ink-deep with a backdrop blur over the hero, near opaque
   after 80px of scroll. Below 860px the nav collapses to a disclosure panel.
2. Hero, full bleed, min-height 100svh. Background is a looping video at
   assets/hero-loop.mp4 with a poster fallback. On top: "Stillwater" as a small
   eyebrow, then the display headline "Where the / evening slows down." on two
   lines, then a star row reading "4.9 - 214 quiet stays on the lake", then the
   booking widget described below.
3. Booking widget, inside the hero, floating card on --ink-deep at 86% with a
   backdrop blur, one small amber arrow glyph in the corner. A two line display
   legend: "Reserve the quiet," then a dimmed second line. Each field is its
   own recessed panel with the label living inside it, not a label sitting
   above a box. Check in date, check out date, guest stepper as minus, count,
   plus, and a cream "Check availability" pill with an arrow. Pure client side.
   On submit, show a friendly inline message. Two night minimum, refuse ranges
   shorter than that with a clear message. Never let checkout precede checkin.
4. "A note from the shore" intro paragraph, then four stats in a row:
   Sleeps 6 / 180 ft of private shoreline / 40 min from the Cascades foothills
   / 100% yours alone. Each with one supporting sentence.
5. The Spaces: section eyebrow "Inside Stillwater", heading "The spaces you'll
   settle into". Five cards, each with an image, a small tag, a title and two
   lines of copy: great room, kitchen, primary bedroom, bath, dock.
6. Amenities, dark band on --ink-deep. Heading "The good stuff, all included"
   left, a short lead paragraph bottom right. Three tall 3:4 cards, each a
   photograph with a bottom weighted gradient and the title and copy sitting
   ON the image, not under it. Below them a flat inline list of the smaller
   inclusions: eight of them, dot separated, no cards.
7. Gallery on --paper: heading "A look around", CSS-columns masonry of six
   images, click to open a lightbox built on <dialog>.
8. Reviews, dark band. Heading left, "4.9 average - 214 stays" with a star row
   right. Four testimonial cards on a recessed panel, each with its own amber
   star row, the quote, a rule, then initials in an amber circle with name and
   city.
9. Rates on --paper: "From $540" over "a night" on two lines, the terms, and a
   two column checklist with amber ticks. Beside it a dark calculator card that
   repeats the date and guest fields, then a ledger reading "$540 x N nights",
   "Cleaning fee $180" and a heavier "Total", all updating live. Its CTA is the
   one amber button on the page.
10. The Host: full bleed photo on the left, copy on the right. Email
    stay@stillwatercabin.com, phone +1 (360) 555-0188, location Snoqualmie
    region, WA, and a dark pill CTA.
11. Closing band: the same looping video as background, centred, heading "Come
    find your quiet", cream CTA.
12. Footer on --ink-deep: four columns, a bottom bar with the copyright "2026
    Stillwater Cabin" and legal links, and an oversized ghost wordmark bled off
    the bottom at 4% opacity, aria-hidden.

IMAGES
Reference every image as assets/NN_role.jpg with role based names. Do not embed
base64 and do not use placeholder services. Every img has explicit width and
height attributes and loading="lazy" except the first one.

NON NEGOTIABLE
- Semantic HTML. section, header, nav, figure, not a wall of divs.
- The hero video tag carries muted, playsinline, loop, autoplay,
  preload="metadata" and a poster. Without muted and playsinline iOS shows a
  black rectangle.
- prefers-reduced-motion: reduce hides the video and falls back to the poster
  as a background image, for both video sections.
- Every color, radius and spacing value is a custom property.
- Text contrast at least 4.5:1 against the brightest frame of the video, not
  the average. Grade the source darker rather than adding a full width overlay.
- Layout checked at 360, 768 and 1440.
- All headings in a single descending order. One h1 on the page.
```

**דגשים על הפרומפט עצמו**

* **המספרים הם עוגנים.** 540, 214, 4.9, 180 ft. בלי מספרים קונקרטיים המודל ממציא קופי גנרי בכל הרצה, והתוצאה לא תהיה זהה בין תלמיד לתלמיד.
* **שמות קבצים לפני שהקבצים קיימים.** `assets/NN_role.jpg` נקבע עכשיו כדי שהתמונות בשלב 3 ייכנסו לתוך מקום מוכן. סחיפה בשמות עולה סבב שלם.
* **החוקים בסוף, לא בהתחלה.** מודלים מכבדים אילוצים שמופיעים אחרי התיאור טוב יותר מאשר לפניו.
* **"self contained" הוא ויתור מודע.** קובץ אחד מקל על תלמידים, ומייצר חוב טכני. תגיד את זה.

**דגש: הכרום כהה, וזו לא החלטת טעם**

הגרסה הראשונה של הווידג'ט הייתה כרטיס בהיר על ההירו, וההערה שחזרה עליה הייתה
"נראה גנרי". היא צדקה, והסיבה ניתנת לניסוח מדויק: **כרטיס בהיר על צילום כהה
נקרא כמדבקה שהודבקה על התמונה. כרטיס כהה יותר מהפריים נקרא כחלק ממנה.**

זה חל על כל מה שצף מעל צילום: ה header, ווידג'ט ההזמנות, פסי הרקע. ברגע
שקובעים את זה, שאר ההחלטות נגזרות מעצמן:

* **הכפתור הראשי הולך אחרי המשטח.** קרם על כהה, כהה על בהיר, ענבר שמור לכפתור
  אחד יחיד בכל הדף. הבריף המקורי אמר "ענבר על כל CTA ראשי", וזה מייצר שלושה
  כפתורי ענבר שמתחרים זה בזה. סטייה מודעת, ותגיד לתלמידים שסטית.
* **ענבר הוא פיסוק, לא משטח.** נקודה של 6 פיקסלים לפני כל eyebrow, בית קטן
  בלוגו, כוכבים, וי ברשימת המחירים. הוא נוכח בכל מסך ולא תופס אף מסך.
* **התווית חיה בתוך השדה, לא מעליו.** תווית מעל תיבה נקראת כטופס. תווית בתוך
  פאנל שקוע נקראת כאובייקט אחד. זה ההבדל היחיד בין הווידג'ט שנראה גנרי לזה
  שנראה מכוון, וזה שינוי של שמונה שורות CSS.
* **פינות נדיבות.** 26 פיקסלים על כרטיסים ומדיה, פיל מלא על כפתורים.

**דגש: טוקן שלא הגדרת הוא אפס, לא שגיאה**

בזמן הבנייה כתבתי `border-radius: var(--radius-xl)` לפני שהגדרתי את הטוקן.
CSS לא זורק שגיאה ולא נופל לערך קודם. הוא פשוט מתעלם מהמאפיין, והכרטיס יצא
עם פינות מרובעות. שום דבר בקונסולה לא רמז על זה.

זו התקלה הכי שקטה בעבודה עם custom properties, והכלל פשוט: **תגדיר את סולם
הטוקנים במלואו לפני שאתה משתמש בשם הראשון.** אל תוסיף טוקן תוך כדי כתיבה.

---

## שלב 3: עשר התמונות

מודל: GPT Image 2 דרך Higgsfield. עשרה רנדרים, וכולם חייבים להיראות כמו אותו בית.

**דגש, וזה החשוב ביותר בשלב הזה**
עקביות היא לא תוצאה של פרומפט טוב. היא תוצאה של פסקת עוגן זהה שמודבקת בכל אחת מעשר הקריאות, בלי לשנות בה מילה.

```
ANCHOR, identical in every render:
A modern two storey lakefront cabin in the Washington Cascades. Flat
cantilevered roof with a deep overhang, blackened steel frame, warm vertical
cedar cladding, floor to ceiling glass on every elevation. The cabin sits low on
a dark stone plinth right at the water's edge, with a timber dock reaching out
in front of it and dense fir forest close behind. Interior palette: sage green
upholstery, soapstone counters, pale oak floors, brushed brass fixtures.
Overcast morning light, low mist on the water, no direct sun. Photographic,
architectural digest style, 35mm, natural color, no people.

SHOT 01: exterior, three quarter view from the dock, the whole cabin in frame,
lake in the foreground.
```

**דגש שנולד מהרצה אמיתית: עוגן חומרים הוא לא עוגן בניין**

הגרסה הראשונה של הפסקה הזו תיארה רק חומרים: פלדה, ארז, זכוכית, אבן סבון, אורן
בהיר. הרצנו איתה עשרה רנדרים. התוצאה הייתה מאלפת: **החומרים נשמרו מושלם והבניין
נסחף.** הספה בגוון מרווה הופיעה זהה בשלושה שוטים שונים, אבל שוט 01 החזיר בית
דו קומתי על שפת המים, שוט 02 החזיר מרפסת של מבנה חד קומתי, ושוט 10 מיקם את
הבית על צוק מיוער. שלושה בתים.

הסיבה פשוטה. המודל ממלא כל מה שלא אמרת. פסקת העוגן הראשונה לא אמרה מילה על
מסה, גובה, צורת גג או מיקום ביחס למים, ולכן הוא המציא אותם מחדש בכל קריאה.

הכלל: **עוגן חייב לתאר את מה שאסור שישתנה, לא את מה שיפה לתאר.** ברשימה הזו
נכנסים מספר קומות, צורת גג, יחס לקרקע ולמים, ומה נמצא ברקע. חומרים לבדם הם
החלק הקל, והם גם החלק שהמודל היה שומר בלי עזרתך.

והכלל שנגזר ממנו, וזה החשוב: **כשמתקנים את העוגן, מריצים מחדש את כל העשר.**
לתקן שני רנדרים חורגים בשורת ה SHOT שלהם זה טלאי שסותר את כל השיטה, כי מרגע
זה הפסקה כבר אינה זהה בין הקריאות. עשרה רנדרים הם יחידה אחת. הם מתוקנים ביחד
או בכלל לא.

עשרת השוטים, לפי הסדר שישרת אותנו בטיסה בהמשך:

| # | השוט | תפקיד באתר |
|---|---|---|
| 01 | חוץ מהמזח | הירו וגלריה |
| 02 | מרפסת, מבט פנימה דרך הזכוכית | מעבר |
| 03 | חלל מרכזי, ספה בגוון מרווה | The Spaces |
| 04 | קמין ואח | Amenities |
| 05 | מטבח, אי אבן סבון | The Spaces |
| 06 | פינת אוכל | גלריה |
| 07 | חדר שינה ראשי | The Spaces |
| 08 | אמבט אבן | The Spaces |
| 09 | סאונה | Amenities |
| 10 | מזח בשקיעה | סגירה |

**דגשים**

* תפסול כל רנדר שבו חומר משתנה. ספה ירוקה שהופכת לאפורה בין שוט 3 לשוט 7 תישבר בטיסה, שם שני הפריימים מופיעים ברצף.
* אל תבקש אנשים. בני אדם בין רנדרים לא נשמרים, וטיסת מצלמה חושפת את זה מיידית.
* שמור את הרנדרים ברזולוציה מלאה, לא את הגרסה שדחסת לאתר. הטיסה תשתמש במקור.
* **כל עשרת הרנדרים ביחס גובה רוחב אחד.** הפיתוי הוא לתת לחיצוניים 3:2 ולפנימיים 4:3 לפי התפקיד באתר. אל תעשה את זה. רגל טיסה מאינטרפולציה בין שני עוגנים, ושני פריימים בצורות שונות לא נותנים לה מה לרנדר. יחס גובה רוחב הוא החלטה של הטיסה, לא של הלייאאוט.

**דגש קריטי: כבה את שיפור הפרומפט האוטומטי**

לכל פלטפורמת ג'נרציה יש מתג "שפר את הפרומפט", והוא כמעט תמיד דלוק כברירת מחדל.
ב Kolbo זה `enhance_prompt`, ב Higgsfield ובאחרות זה בשמות אחרים. המתג הזה משכתב
את הטקסט שלך לפני שהוא מגיע למודל.

תחשוב מה זה עושה לשיטה שלמדנו עכשיו. כל השיטה נשענת על כך שאותה פסקה מגיעה
למודל **זהה בייט בייט** עשר פעמים. שכתוב אוטומטי מייצר עשר גרסאות שונות של
העוגן, כלומר אין יותר עוגן.

וזה הצד המרושע: התסמין לא נראה כמו באג בפלטפורמה. הוא נראה בדיוק כמו מודל לא
עקבי. התלמיד יראה עשרה בתים שונים, יסיק "המודל גרוע", וילך לחפש מודל אחר, שם
הוא ייתקל באותו מתג. תגיד את זה במפורש ותראה איפה המתג יושב במסך.

**דגש: הרזולוציה שהתווית מבטיחה היא לא הרזולוציה שקיבלת**

"1K" ב 3:2 החזיר 1024x688, לא 1536x1024. תמדוד את הקובץ שחזר לפני שאתה כותב
`width` ו `height` ב HTML, ואל תנפח אותו למספר עגול יותר. אפסייל מ 1024 ל 1600
הוסיף לנו 40 אחוז בייטים ואפס פיקסלים.

---

## שלב 4: וידאו ההירו

מודל: Seedance 2.0. קלט: רנדר 01.

```
Animate this image. No zoom in, no zoom out, no camera move.
Subtle looping motion only: mist drifting right to left, small ripples on the
water, leaves moving slightly. Everything else stays still.
```

קידוד, בדיוק כמו בפייפליין הקיים שלך:

```bash
ffmpeg -i raw.mp4 -vf "scale=1920:-2,fps=30" -c:v libx264 -crf 26 \
  -preset slow -pix_fmt yuv420p -an -movflags +faststart \
  assets/hero-loop.mp4

ffmpeg -i assets/hero-loop.mp4 -vframes 1 -q:v 2 assets/hero-poster.jpg
```

**דגשים**

* `-pix_fmt yuv420p` הוא ההבדל בין וידאו שעובד לבין מלבן שחור על מכשירי אפל בלבד. זו התקלה שמתגלה הכי מאוחר.
* פרומפט קצר מנצח פרומפט ארוך. מודלי וידאו מוסיפים תנועה בנדיבות, וכל סעיף נוסף הוא עוד משהו להילחם בו.
* תקציב: mp4 מתחת ל 3MB, פוסטר מתחת ל 200KB.

---

## שלב 5: בדיקת מסירה למסלול א

* אין ערך צבע או מרווח מחוץ ל custom property
* `prefers-reduced-motion` מטופל בשני קטעי הווידאו
* לכל תמונה יש width ו height, CLS מתחת ל 0.1
* נבדק ב 360, 768, 1440
* ווידג'ט ההזמנות מסומן בבירור כדמו ולא מתחזה למערכת אמיתית

---

# מסלול ב: הטיסה

כאן נכנס Claude Code. הרעיון: הגלילה לא מנפישה כלום. היא רק מזיזה את ה playhead של וידאו שכבר מרונדר.

```
scroll position  →  video.currentTime
```

זו הסיבה שזה חלק בשני הכיוונים, ולא צורך שום ספריית אנימציה.

---

## שלב 6: המסירה

```bash
unzip stillwater.zip -d stillwater && cd stillwater
claude
```

**דגש**
שום דבר לא נבנה מחדש. האתר המוגמר עובר שלם, כולל הרנדרים. אם המודל מתחיל לשכתב את ההירו, הבריף היה רחב מדי.

---

## שלב 7: חוק התפר

זה החלק החכם בכל הפרויקט, והוא זה שהכי פחות מוסבר במקור.

הטיסה מורכבת משבע רגליים. **כל רגל מרונדרת עם first frame ו last frame נעולים על רנדרים קיימים מהאתר.**

```
רגל 1:  01 חוץ        →  02 מרפסת
רגל 2:  02 מרפסת      →  03 חלל מרכזי
רגל 3:  03 חלל מרכזי  →  05 מטבח
רגל 4:  05 מטבח       →  04 קמין
רגל 5:  04 קמין       →  07 חדר שינה
רגל 6:  07 חדר שינה   →  08 אמבט
רגל 7:  08 אמבט       →  10 מזח
```

שמונה עוגנים, שבע רגליים.

**למה זה עובד**
הפריים האחרון של רגל N הוא בדיוק אותה תמונה כמו הפריים הראשון של רגל N+1. לא דומה, אותה תמונה. לכן החיבור בין הקטעים אינו חיתוך, הוא רצף. וכיוון שהעוגנים הם הרנדרים שכבר יושבים בעמוד, החדרים בסרטון הם אותם חדרים בדף. אותה ספה, אותו אי, אותו אמבט.

**דגש**
זה גם המקום שבו זה נשבר. אם רנדר אחד לא עקבי עם השאר, שתי רגליים סמוכות ייראו כמו שני בתים שונים, ואי אפשר לתקן את זה בעריכה. עקביות בשלב 3 היא תנאי מקדים, לא ליטוש.

הפרומפט לכל רגל:

```
First frame: [anchor_A.jpg]
Last frame:  [anchor_B.jpg]

One continuous camera move between them. Slow, steady, cinematic dolly.
No cuts, no zoom snaps, no shutter effects. Keep the exact materials, colors
and furniture from both frames. Overcast daylight throughout.
Duration: 5s.
```

---

## שלב 8: איחוד וקידוד לגלילה

כאן ההבדל הגדול מהפייפליין של וידאו הירו. **וידאו שגוללים בו ווידאו שמנגנים בלופ הם שני קידודים שונים לגמרי.**

הסרת הפריים הכפול בכל תפר, ואיחוד:

```bash
for f in leg_*.mp4; do
  ffmpeg -i "$f" -vf "select='not(eq(n\,$(($(ffprobe -v error -select_streams v:0 \
    -count_frames -show_entries stream=nb_read_frames -of csv=p=0 "$f")-1)))'" \
    -vsync vfr -an "trimmed_$f"
done

printf "file '%s'\n" trimmed_leg_*.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy flight_raw.mp4
```

הקידוד לגלילה:

```bash
ffmpeg -i flight_raw.mp4 \
  -vf "scale=1600:-2,fps=30" \
  -c:v libx264 -crf 24 -preset slow -pix_fmt yuv420p \
  -x264-params "keyint=5:min-keyint=5:scenecut=0" \
  -tune fastdecode -an -movflags +faststart \
  assets/flight_desktop.mp4

ffmpeg -i flight_raw.mp4 \
  -vf "scale=960:-2,fps=24" \
  -c:v libx264 -crf 26 -preset slow -pix_fmt yuv420p \
  -x264-params "keyint=5:min-keyint=5:scenecut=0" \
  -tune fastdecode -an -movflags +faststart \
  assets/flight_mobile.mp4
```

**הדגש הכי חשוב בכל השיעור**

`keyint=5`. וידאו רגיל שם keyframe כל 250 פריימים. כדי לקפוץ לפריים 137 הדפדפן חייב לפענח מהקיפריים הקודם קדימה. בנגינה רגילה זה לא מורגש. בגלילה זה קפיצות. keyframe כל 5 פריימים פותר את זה במחיר ניפוח של הקובץ פי 2 עד 3. זו הסיבה שרזולוציית הדסקטופ יורדת ל 1600 ולא ל 1920: התקציב הולך ל keyframes ולא לפיקסלים.

`-tune fastdecode` מוותר על כלים שמכבידים על הפענוח. בסקראב מפענחים עשרות פעמים בשנייה.

**תקציב**
טיסה של 35 שניות ב 1600 עם keyint=5 היא בערך 8 עד 14MB. זה מעל כל תקציב הירו סביר, וזה בסדר, כי זה לא הירו. מה שלא בסדר זה לשלוח את זה למובייל סלולרי, ולכן יש שתי גרסאות ופולבק.

---

## שלב 9: מנוע הסקראב

```html
<section class="flight" style="height: 700vh">
  <div class="flight__stage">
    <video class="flight__video" muted playsinline preload="auto"
           poster="assets/flight_poster.jpg">
      <source src="assets/flight_desktop.mp4" type="video/mp4">
    </video>
  </div>
</section>
```

```css
.flight { position: relative; }
.flight__stage {
  position: sticky; top: 0;
  height: 100svh;
  overflow: hidden;
}
.flight__video {
  width: 100%; height: 100%;
  object-fit: cover;
}
@media (prefers-reduced-motion: reduce) {
  .flight { height: 100svh; }
  .flight__video { display: none; }
  .flight__stage { background: url("assets/flight_poster.jpg") center / cover; }
}
```

```js
const section = document.querySelector('.flight');
const video   = section.querySelector('.flight__video');

let target = 0, current = 0, raf = null, ready = false;

video.addEventListener('loadedmetadata', () => { ready = true; });

function progress() {
  const travel = section.offsetHeight - window.innerHeight;
  const passed = -section.getBoundingClientRect().top;
  return Math.min(1, Math.max(0, passed / travel));
}

function tick() {
  current += (target - current) * 0.12;
  if (Math.abs(target - current) < 0.0004) current = target;

  if (ready && video.readyState >= 2) {
    const t = current * video.duration;
    if (typeof video.fastSeek === 'function') video.fastSeek(t);
    else video.currentTime = t;
  }

  raf = current === target ? null : requestAnimationFrame(tick);
}

window.addEventListener('scroll', () => {
  target = progress();
  if (raf === null) raf = requestAnimationFrame(tick);
}, { passive: true });
```

**דגשים**

* **הווידאו לעולם לא מנוגן.** אין `autoplay`, אין `play()`. רק `currentTime`.
* **ה lerp הוא לא קישוט.** בלי ההחלקה של 0.12, כל אירוע גלילה מייצר seek נפרד, והדפדפן מציף את מפענח הווידאו. עם ההחלקה, מספר ה seeks נקבע לפי קצב הפריימים ולא לפי קצב הגלילה.
* **`preload="auto"` כאן, לא `metadata`.** זו סטייה מודעת מכלל ההירו הרגיל. אי אפשר לגלול לתוך משהו שלא ירד. אם כן משתמשים ב metadata, הגלילה הראשונה תמיד קופאת.
* **iOS דורש נגיעה ראשונה.** בסאפארי, seek לפני אינטראקציה של המשתמש לפעמים לא מרנדר פריים. פתרון: `video.play().then(() => video.pause())` בתוך מאזין `touchstart` חד פעמי.
* **`readyState >= 2` הוא שומר סף.** בלעדיו, seek לפני שיש נתונים זורק ומשאיר פריים שחור.
* **גובה הסקשן קובע את הקצב.** 700vh לטיסה של 35 שניות זה בערך 20vh לשנייה. פחות מ 100vh לשנייה של וידאו מרגיש נמרץ מדי.

---

## שלב 10: הפולבקים, וזה לא אופציונלי

| מצב | התנהגות |
|---|---|
| `prefers-reduced-motion` | סקשן בגובה מסך אחד, תמונת פוסטר סטטית |
| רוחב מתחת ל 768 | `flight_mobile.mp4`, גובה סקשן 400vh |
| `navigator.connection.saveData` | פוסטר בלבד, אין הורדת וידאו |
| הווידאו לא נטען | הפוסטר כבר שם, אין מסך שחור |

**דגש**
סקשן בגובה 700vh בלי וידאו הוא שבעה מסכים ריקים שהמשתמש גולל בהם לשווא. כל פולבק חייב גם לכווץ את הגובה, לא רק להסתיר את הווידאו. זו התקלה שהכי קל לפספס כי היא לא נראית במחשב שלך.

---

## שלב 11: עמוד ה case study

אם מלמדים לתעד, מתעדים נכון.

**הבאג במקור**
שני העמודים נשלחים עם התבניות לא ממולאות. ה HTML הגולמי מכיל ליטרלית `{{ promptText }}` ו `{{ m.name }}`. קראולרים, לינק פרוויוז ומודלי שפה מקבלים ג'יבריש. הפרומפט, שהוא הנכס היחיד בעמוד, פשוט לא קיים ב HTML.

**הכלל לתלמידים**
כל תוכן שהמטרה שלו היא להישלח, להשתף או להיקרא, חייב להיות ב HTML הסטטי. JavaScript מקבל אינטראקטיביות בלבד. אם חשוב לך שהעמוד ייקרא, אל תסתיר את התוכן מאחורי הידרציה.

---

## LEARNINGS

מה חסום, ומה לחזור עליו.

**חסום**

* אי אפשר לתקן חוסר עקביות בין רנדרים בשלב הטיסה. אין עריכה שמצילה את זה.
* אי אפשר לתקן עוגן חלש בשוט בודד. או שמתקנים את הפסקה ומריצים את כל העשר, או שחיים עם הסחיפה.
* אי אפשר לגלול בחלקות בקידוד רגיל. keyint ארוך שווה קפיצות, נקודה.
* אי אפשר לוותר על `muted` ו `playsinline` ב iOS. אלה לא שיפורים, בלעדיהם אין וידאו.
* אי אפשר להישאר בתקציב הירו של 3MB בווידאו סקראב. זה סוג אחר של נכס.

**לחזור עליו**

* משפחת פונט אחת לכל המערכת, והיררכיה ממשקל ומ tracking במקום מניגוד serif ו sans
* כרום כהה מתחת לכל דבר שצף על צילום. כרטיס בהיר על תמונה כהה נראה כמדבקה
* הכפתור הראשי הולך אחרי המשטח, וענבר נשאר פיסוק ולא משטח
* תווית בתוך השדה, לא מעליו
* להגדיר את כל סולם הטוקנים לפני השימוש הראשון. טוקן חסר הוא אפס שקט
* פסקת עוגן זהה מילה במילה בכל קריאה למודל תמונה, ובפסקה יש גם מסה וגם חומרים
* לכבות שיפור פרומפט אוטומטי לפני הקריאה הראשונה, לא אחרי שהתוצאות מאכזבות
* יחס גובה רוחב אחד לכל העוגנים, כי הטיסה קובעת אותו ולא הלייאאוט
* כשמתקנים את העוגן, מריצים מחדש את כל הסט. עשרה רנדרים הם יחידה אחת
* עוגנים דו צדדיים: first frame ו last frame נעולים על תמונות שכבר קיימות בעמוד
* שמות קבצים נקבעים לפני שהקבצים קיימים
* מספרים קונקרטיים בפרומפט במקום תיאורים איכותיים
* פרומפטים קצרים למודלי וידאו, ארוכים למודלי קוד
* lerp בין gap הגלילה ל currentTime, תמיד

---

## הצעה לסקילים

שני דברים כאן חוזרים על עצמם בכל פרויקט וידאו שתעשה, וכדאי להוציא אותם מהשיעור ל skills:

**1. `scroll-scrub`**
מקבל תיקיית רגליים, מריץ את הסרת הפריים הכפול, ה concat, ושני הקידודים עם `keyint=5`, מזריק את ה HTML, ה CSS ומנוע ה lerp, וכותב את כל הפולבקים. ה skill `reference-to-site` שלך כבר מכסה וידאו הירו אבל הקידוד שם הפוך למה שנדרש כאן, ולכן זה skill נפרד ולא סעיף נוסף בקיים.

**2. `case-study-page`**
המבנה חוזר בדיוק פעמיים באתר המקורי: רפרנס, קונקטור, מודלים והגדרות, פרומפט מלא. עם טוקנים של Forge, RTL, ופלט HTML סטטי מלא, כל פרויקט סטודיו מקבל עמוד "איך זה נבנה" תוך דקות, ובלי הבאג של המקור.
