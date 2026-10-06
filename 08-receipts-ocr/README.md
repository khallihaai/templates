# حوّل صور الإيصالات الورقية إلى جدول إكسل واحد تلقائياً (قالب n8n مجاني)
**Turn photos of paper receipts into one Excel sheet automatically (free n8n template)**

قالب مجاني من قناة «خلّيها على الـAI» على يوتيوب: https://www.youtube.com/@khallihaai

## الفكرة
عندك كومةُ إيصالات ورقية وتُدخلها في إكسل يدوياً؟ هذا القالب يقرأ **كل صور الإيصالات في مجلد دفعةً واحدة**،
ويشغّل عليها **قراءةً ضوئية (OCR) محلية** تحوّل كل صورة إلى نص، ثم تلتقط **التاريخ** و**المبلغ** و**اسم المتجر**
بقواعد بسيطة، وتكتب كل ذلك في ملفٍ واحد: `output/receipts.xlsx` فيه **تبويبان**: «الإيصالات» (صفٌّ لكل إيصال
فيه الملف والمتجر والتاريخ والمبلغ والحالة) و«الملخص» (عدد الإيصالات + المكتملة + التي تحتاج مراجعة + مجموع
المبالغ). كل شيء يعمل على جهازك، مجاناً، **بدون نموذج لغوي (LLM) وبدون إنترنت** — وصورك لا تغادر جهازك.

## سير العمل
«عند الضغط على تنفيذ» ← «اقرأ صور الإيصالات» (نمط `input/*.jpg` يقرأ كل الصور) ← «اقرأ النص من كل صورة»
(عقدة Code تشغّل `tesseract` على كل صورة وتلتقط التاريخ/المبلغ/المتجر + حالة لكل صورة) ← يتفرّع إلى:
«ملخص الحالة» (عقدة Summarize تعدّ «تم» و«مراجعة» مباشرةً)، و«ابنِ جدول الإكسل» (عقدة Code فيها بضعة أسطر
جاهزة تبني الملف بتبويبَين) ← «احفظ ملف الإكسل» (`output/receipts.xlsx`).

## الحالة: «تم» أم «مراجعة»؟
القراءة الآلية سريعة لكنها ليست مثالية. إذا التقط القالبُ **التاريخ والمبلغ واسم المتجر** جميعاً، يضع حالة
«تم». وإذا نقص أحدها (مثلاً لم يتّضح اسم المتجر في الصورة)، يضع الصفَّ في حالة «مراجعة» ويكتب الحقل الناقص —
فتراجع القليلَ المعلَّم فقط بدل كل الصفوف.

## الخطوات
1. ثبّت n8n على جهازك (مجاني للتشغيل الذاتي، برخصة fair-code — Sustainable Use License). مثلاً: `npx n8n`.
2. ثبّت محرّك القراءة الضوئية **tesseract** مع بيانات اللغة العربية (`ara`) والإنجليزية (`eng`)، وتأكّد أن
   الأمر `tesseract` متاحٌ في مسار النظام (PATH). (على Debian/Ubuntu مثلاً: حزمتا `tesseract-ocr`
   و`tesseract-ocr-ara`.)
3. أنشئ مجلداً، وبداخله مجلدان: `input` (ضع فيه صور إيصالاتك `.jpg`) و`output` (فارغ).
   للتجربة: انسخ صور `sample/` السبع (بيانات تجريبية) إلى `input/`.
4. شغّل n8n **من داخل هذا المجلد**، واسمح له بقراءة ملفاته، واسمح لعقدة Code باستخدام الأوامر المدمجة
   (لتشغيل tesseract) ومكتبة الإكسل المضمّنة:
   ```
   cd my-receipts
   N8N_RESTRICT_FILE_ACCESS_TO="$PWD" NODE_FUNCTION_ALLOW_BUILTIN="*" NODE_FUNCTION_ALLOW_EXTERNAL=@e965/xlsx npx n8n
   ```
   (`@e965/xlsx` مكتبة الجداول المضمّنة داخل n8n — لا تثبيت إضافي. عقدة Code تعمل عبر مشغّل المهام المدمج،
   وهو مُفعّل افتراضياً في الإصدارات الحديثة.)
5. في n8n: استورد `workflow.json` (Import from file).
6. اضغط **Execute workflow**. النتيجة في `output/receipts.xlsx`: تبويب «الإيصالات» وتبويب «الملخص».

> **صدق مهم:** هذا القالب **ليس «بدون سطر برمجة»** — فيه عقدتا Code (واحدة للقراءة الضوئية، وواحدة لبناء
> الملف). وليس «بدون ذكاء اصطناعي» تماماً، لأن محرّك القراءة الضوئية (OCR) نموذجٌ أيضاً — لكنه **محلي ومجاني،
> يعمل على جهازك، بدون نموذج لغوي (LLM) وبدون إنترنت**، وصورك لا تُرفع إلى أي خدمة. الأداة n8n **fair-code**
> (ليست «مفتوحة المصدر»). البيانات في `sample/` تجريبية (أسماء متخيّلة، لا أشخاص ولا محل حقيقي). راجِع
> الصفوف المعلَّمة «مراجعة» قبل اعتماد الجدول.

## عدّله لك
- **التقط حقلاً آخر** (رقم الفاتورة، طريقة الدفع…): أضِف قاعدةً بسيطة في عقدة «اقرأ النص من كل صورة».
- **كلمات «الإجمالي» مختلفة في إيصالاتك؟** عدّل قائمة الكلمات (`TOTAL_KW`) لتناسبها.
- **صيغ تاريخ أخرى:** وسّع تعبير التاريخ (`DATE_RE`) ليشمل صيغتك.
- **PNG بدل JPG:** غيّر النمط في «اقرأ صور الإيصالات» إلى `input/*.png` (أو `input/*`).

---

## English
Got a pile of paper receipts you type into Excel by hand? This template reads **every receipt photo in a
folder at once** (`input/*.jpg`), runs a **local OCR engine (tesseract)** on each image to turn it into text,
then pulls out the **date**, **total** and **shop name** with simple rules, and writes everything to one file:
`output/receipts.xlsx` with **two tabs** — «الإيصالات» (one row per receipt: file, shop, date, total, status)
and «الملخص» (count + completed + needs-review + sum of totals). Runs fully on your machine, free,
**no LLM and no internet** — your photos never leave your computer.

### Flow
Manual trigger → **Read File(s) From Disk** (`input/*.jpg` reads all of them) → **Code: OCR each image**
(runs `tesseract` on every image and pulls date/total/shop + a per-image status) → fans out to a **Summarize**
node (counts «تم» vs «مراجعة» live) and a small **Code** node (a few ready lines that build the two-tab workbook
with n8n's bundled `@e965/xlsx`) → **Write File to Disk** (`output/receipts.xlsx`).

### Status: «تم» (done) or «مراجعة» (review)?
Automatic reading is fast but not perfect. If the template captured the **date, total and shop name**, the row
is marked «تم». If one is missing (e.g. the shop name wasn't clear in the photo), the row is marked «مراجعة»
with the missing field noted — so you only check the few flagged rows, not every row.

### Steps
1. Install n8n (free to self-host, fair-code — Sustainable Use License), e.g. `npx n8n`.
2. Install the **tesseract** OCR engine with the Arabic (`ara`) and English (`eng`) language data, and make
   sure `tesseract` is on your PATH. (On Debian/Ubuntu: `tesseract-ocr` and `tesseract-ocr-ara`.)
3. Make a folder with `input/` (your receipt `.jpg` photos) and `output/` (empty). To try it, copy the seven
   `sample/` photos (sample data) into `input/`.
4. Start n8n **from that folder**, allowing file access and letting the Code node use built-in modules (to run
   tesseract) and n8n's bundled Excel library:
   ```
   cd my-receipts
   N8N_RESTRICT_FILE_ACCESS_TO="$PWD" NODE_FUNCTION_ALLOW_BUILTIN="*" NODE_FUNCTION_ALLOW_EXTERNAL=@e965/xlsx npx n8n
   ```
   (`@e965/xlsx` is the spreadsheet library bundled inside n8n — no extra install. The Code node runs via n8n's
   built-in task runner, enabled by default in recent versions.)
5. Import `workflow.json` (Import from file), then click **Execute workflow**.
6. The result is `output/receipts.xlsx` with an «الإيصالات» tab and a «الملخص» tab.

> **Honesty note:** this template is **not "no-code"** — it has two **Code** nodes (one for OCR, one to build
> the file). It is not quite "no AI" either, since an OCR engine is also a model — but it is **local and free,
> runs on your machine, with no LLM and no internet**, and your images are never uploaded. n8n is **fair-code**
> (Sustainable Use License), **not** "open-source". The files in `sample/` are SAMPLE DATA (invented names, no
> real people or shop). Always review the rows flagged «مراجعة» before trusting the sheet.

Adapt it:
- **Capture another field** (invoice number, payment method…): add a small rule in the «اقرأ النص من كل صورة» node.
- **Different total wording:** edit the keyword list (`TOTAL_KW`) to match your receipts.
- **Other date formats:** widen the date pattern (`DATE_RE`).
- **PNG instead of JPG:** change the pattern in «اقرأ صور الإيصالات» to `input/*.png` (or `input/*`).

Built for Linux with self-hosted n8n and a local tesseract. No LLM and no internet needed. The template files
are under the MIT licence (see LICENSE). n8n itself is fair-code (Sustainable Use License), **not** "open-source".
