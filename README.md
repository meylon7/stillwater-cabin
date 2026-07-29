# Stillwater

בית נופש על אגם בקסקיידס. אתר בקובץ אחד, ואותו בית עצמו כטיסת מצלמה רציפה
שהגלילה מניעה.

נבנה לפי `stillwater_flight_lesson.md`.

## מבנה

```text
index.html            האתר. self contained: כל ה-CSS ב-style, כל ה-JS ב-script.
case-study.html       "איך זה נבנה". HTML סטטי מלא, בלי הידרציה.
PROMPTS.md            פסקת העוגן, 10 השוטים, 7 רגלי הטיסה. הנכס האמיתי.
assets/
  manifest.json       מקור האמת לכל שם קובץ, מידה ותפקיד.
  NN_role.jpg         11 תמונות, בגרסה הדחוסה לדף.
  hero-poster.jpg     פוסטר ההירו, גם הפולבק ל-reduced-motion.
  flight_poster.jpg   פוסטר הטיסה, גם הפולבק ל-saveData.
  hero-loop.mp4       לופ ההירו.        קידוד נגינה.
  flight_*.mp4        הטיסה, 2 גרסאות.  קידוד סקראב. שני דברים שונים לגמרי.
media/
  anchors/            הרנדרים ברזולוציה מלאה. הטיסה נבנית מכאן, לא מ-assets.
  legs/               7 הרגליים הגולמיות כפי שיצאו מהמודל.
scripts/
  make-placeholders.ps1   מייצר JPG במידות הסופיות לכל ערך ב-manifest.
  encode-hero.sh          לופ ההירו.
  build-flight.sh         trim תפרים, concat, שני קידודי סקראב.
```

## טוקנים — נעולים לפני שורת HTML אחת

```css
:root {
  --ink:      #14201d;
  --teal:     #2f5d55;
  --teal-dim: #4a7a70;
  --amber:    #c98f4b;
  --sand:     #f3ede3;
  --paper:    #fbf8f3;
  --font-display: "Cormorant Garamond", Georgia, serif;
  --font-body:    "Inter", system-ui, sans-serif;
}
```

ענבר הוא האקסנט היחיד. הוא מופיע על CTA ראשי ועל דירוגי כוכבים, ובשום מקום אחר.
אין ערך צבע, רדיוס או מרווח מחוץ ל-custom property.

## המספרים — עוגני הקופי

`$540` ללילה · `$180` ניקיון · מינימום 2 לילות · 4.9 מתוך 214 שהיות ·
ישנים 6 · 180 רגל חוף פרטי · 40 דקות ממרגלות הקסקיידס.

בלי מספרים קונקרטיים המודל ממציא קופי גנרי בכל הרצה.

## מצב נוכחי

- [x] שלב 1 — שלד, טוקנים, manifest, פלייסהולדרים, PROMPTS.md
- [x] שלב 2 — header + hero + ווידג'ט הזמנות
- [x] שלב 3א — 10 הרנדרים (GPT Image 2, שני סבבים, 160 קרדיטים)
- [x] שלב 4 — intro, סטטיסטיקות, The Spaces
- [ ] שלב 5 — amenities, גלריה, לייטבוקס, reviews
- [ ] שלב 6 — rates, host, closing band, footer
- [ ] שלב 7 — encode-hero.sh + וידאו ההירו
- [ ] שלב 8 — סקשן הטיסה ומנוע הסקראב
- [ ] שלב 9 — 7 הרגליים + build-flight.sh
- [ ] שלב 10 — case-study.html

עשרת הרנדרים אמיתיים (GPT Image 2, 1024x688). `11_host.jpg` עדיין פלייסהולדר
מוצהר — צריך תמונה של אנשים אמיתיים, לא רנדר.
`hero-loop.mp4` ו-`flight_*.mp4` עדיין לא קיימים. הדף נופל לפוסטר עד שהם יגיעו.

הרנדרים מיוצרים ב-Kolbo. ראה [.kolbo/production.md](.kolbo/production.md) ליומן
ההרצות, ל-generation ids ולעלות בפועל.

## אזהרות

- **עלות.** כל רנדר וכל רגל נצרכים מקרדיטים ב-Higgsfield. בלי יתרה, הפריסה
  תיבנה וכל הפריימים ייכשלו.
- **משפטי.** הקונספט המקורי הוא Stayava NatureNook ב-Behance. משם נלקחו מבנה
  ההירו, זוג הפונטים והפלטה בלבד. דמו פומבי על קונספט של מעצב אחר הוא אזור אפור
  גם עם קרדיט.
- **ווידג'ט ההזמנות הוא דמו.** הוא מסומן ככזה בדף ולא מתחזה למערכת אמיתית.
