# رتّب مجلد التنزيلات الفوضوي تلقائياً ← فواتير وعقود وصور في مجلدات مؤرّخة + سجل إكسل (قالب n8n مجاني)
**Sort a messy downloads folder automatically → invoices / contracts / photos / other into dated folders + a log sheet: free n8n template**

قالب مجاني من قناة «خلّيها على الـAI» على يوتيوب: https://www.youtube.com/@khallihaai

## الفكرة
مجلد التنزيلات يمتلئ بفواتير وعقود وصور ومستندات بأسماء فوضوية مثل `scan0003 (2).pdf`. هذا القالب يقرأ **كل
ملفات المجلد دفعةً واحدة**، ويصنّف كل ملف **بقاعدة واضحة** (لا بالذكاء الاصطناعي):
1. **نوع الملف:** صورة؟ → مجلد «صور».
2. **كلمة داخل نص الـPDF:** «فاتورة» → مجلد «فواتير»، «عقد» → مجلد «عقود»، وإلا → «أخرى».
3. **التاريخ:** يُلتقط من نص الملف أو من اسمه، فيذهب الملف إلى مجلد **شهره** (`YYYY-MM`)، أو إلى «غير-مؤرّخ» إن لم يوجد تاريخ.

ثم يُنسخ كل ملف إلى `sorted/<التصنيف>/<الشهر>/` **باسم نظيف** (مثل `فاتورة-2026-04-02-01.pdf`)، ويُكتب **سجل إكسل**
في `output/سجل-الترتيب.xlsx` فيه كل ملف وتصنيفه وتاريخه ومكانه الجديد. **الأصل يبقى في `downloads/` — لا يُحذف شيء.**
كل شيء يعمل على جهازك، مجاناً، **بدون أي ذكاء اصطناعي وبدون إنترنت**.

## سير العمل
«عند الضغط على تنفيذ» ← «اقرأ مجلد التنزيلات» (نمط `downloads/*` يقرأ كل الملفات) ← «صنّف حسب النوع والتاريخ»
(عقدة Code: تطبّق القاعدة، وتقرأ نص الـPDF بأداة `pdftotext`، وتُنشئ المجلدات) ← يتفرّع إلى: «رتّب الملفات في
مجلدات» (يكتب النسخ إلى `sorted/…`)، و«ملخّص الترتيب» (جدول نظيف على الشاشة)، و«ابنِ سجل الإكسل» (عقدة Code تبني
الجدول) ← «احفظ السجل» (`output/سجل-الترتيب.xlsx`).

## المتطلبات
- **n8n** (مجاني للتشغيل الذاتي، برخصة fair-code — Sustainable Use License). مثلاً: `npx n8n`.
- **poppler-utils** (أداة `pdftotext`) لقراءة نص الـPDF العربي: `sudo apt install poppler-utils`.
- (اختياري) **LibreOffice** — استُخدم فقط لإنشاء ملفات الـPDF التجريبية في `sample/` (نص عربي قابل للقراءة).

## الخطوات
1. أنشئ مجلداً، وبداخله ثلاثة مجلدات: `downloads` (ضع فيه ملفاتك المبعثرة)، و`sorted` (فارغ)، و`output` (فارغ).
   للتجربة: انسخ ملفات `sample/` الثلاثين (بيانات تجريبية) إلى `downloads/`.
2. شغّل n8n **من داخل هذا المجلد**، واسمح له بقراءة ملفاته، واسمح لعقدة Code باستخدام أدوات النظام ومكتبة الإكسل المضمّنة:
   ```
   cd my-downloads
   N8N_RESTRICT_FILE_ACCESS_TO="$PWD" \
   NODE_FUNCTION_ALLOW_EXTERNAL=@e965/xlsx \
   NODE_FUNCTION_ALLOW_BUILTIN='*' \
   N8N_EXPRESSION_ENGINE=legacy \
   npx n8n
   ```
   (`@e965/xlsx` مكتبة الجداول المضمّنة داخل n8n نفسه — لا تثبيت إضافي. `NODE_FUNCTION_ALLOW_BUILTIN` يتيح لعقدة Code
   استدعاء `pdftotext` وإنشاء المجلدات. عقدة Code تعمل عبر مشغّل المهام المدمج في n8n، وهو مُفعّل افتراضياً.)
3. في n8n: استورد `workflow.json` (Import from file).
4. اضغط **Execute workflow**. النتيجة: مجلد `sorted/` مرتّب + ملف `output/سجل-الترتيب.xlsx`.

> **صدق مهم:** هذا القالب **ليس «بدون سطر برمجة»** — فيه عقدات Code صغيرة جاهزة (قراءة وتصنيف، وبناء السجل)؛ أما
> الربط والقراءة والكتابة فبعقدات n8n الجاهزة. الأداة n8n **fair-code** (ليست «مفتوحة المصدر»). القالب **ينسخ**
> الملفات إلى `sorted/` ويترك أصولك في `downloads/`، فهو آمن ويمكن إعادة تشغيله. لا يُستخدم أي نموذج ذكاء اصطناعي،
> ولا يُرفع أي ملف إلى الإنترنت. البيانات في `sample/` تجريبية (أسماء متخيّلة، لا أشخاص ولا جهة حقيقية — SAMPLE DATA).

## عدّله لك
- **تصنيف جديد** (مثل «كشوف الحساب»): أضف كلمةً مفتاحيةً جديدة في عقدة «صنّف حسب النوع والتاريخ».
- **رتّب بالسنة بدل الشهر:** استخدم `iso.slice(0,4)` بدل `iso.slice(0,7)` في اسم المجلد.
- **انقل بدل أن تنسخ:** بعد عقدة الكتابة، احذف الأصل (أو استخدم `fs.renameSync` في عقدة واحدة) — بعد أن تتأكد.
- **أنواع صور أو مستندات إضافية:** أضف الامتداد إلى قوائم `IMG` أو `DOC` في عقدة التصنيف.

---

## English
Your downloads folder fills up with invoices, contracts, phone photos and documents named like
`scan0003 (2).pdf`. This template reads **every file in the folder at once** and classifies each by a clear
**rule** (no AI):
1. **File type:** an image → the «صور» (photos) folder.
2. **A keyword inside the PDF text:** «فاتورة» (invoice) → «فواتير»; «عقد» (contract) → «عقود»; otherwise → «أخرى».
3. **A date:** taken from the PDF text or the file name, so the file lands in its **month** folder (`YYYY-MM`),
   or in «غير-مؤرّخ» (undated) when there is no date.

Each file is then copied into `sorted/<category>/<month>/` with a **clean name** (e.g. `فاتورة-2026-04-02-01.pdf`),
and a **log** is written to `output/سجل-الترتيب.xlsx` listing every file, its category, date and new location.
**The originals in `downloads/` are kept — nothing is deleted.** Runs fully on your machine, free, **no AI, no internet**.

### Flow
Manual trigger → **Read File(s) From Disk** (`downloads/*` reads all of them) → **Code — classify** (applies the
rule, reads PDF text with `pdftotext`, and creates the folders) → fans out to: **Write File to Disk**
(`sorted/<category>/<month>/<clean name>`), a **Code — summary** (a clean on-screen table) and a **Code — build log**
(the log workbook with n8n's bundled `@e965/xlsx`) → **Write File to Disk** (`output/سجل-الترتيب.xlsx`).

### Requirements
- **n8n** (free to self-host, fair-code — Sustainable Use License), e.g. `npx n8n`.
- **poppler-utils** (`pdftotext`) to read the Arabic PDF text: `sudo apt install poppler-utils`.
- (optional) **LibreOffice** — used only to create the test Arabic PDFs in `sample/` (clean text layer).

### Steps
1. Make a folder with `downloads/` (your messy files), `sorted/` (empty) and `output/` (empty). To try it, copy the
   thirty `sample/` files (sample data) into `downloads/`.
2. Start n8n **from that folder**, allowing file access and letting the Code node use system tools + the bundled Excel lib:
   ```
   cd my-downloads
   N8N_RESTRICT_FILE_ACCESS_TO="$PWD" \
   NODE_FUNCTION_ALLOW_EXTERNAL=@e965/xlsx \
   NODE_FUNCTION_ALLOW_BUILTIN='*' \
   N8N_EXPRESSION_ENGINE=legacy \
   npx n8n
   ```
   (`@e965/xlsx` is the spreadsheet library bundled inside n8n itself — no extra install. `NODE_FUNCTION_ALLOW_BUILTIN`
   lets the Code node call `pdftotext` and create folders. The Code node runs via n8n's built-in task runner,
   enabled by default in recent versions. The legacy expression engine is used for the write node's file-name expression.)
3. Import `workflow.json` (Import from file), then click **Execute workflow**.
4. The result is a tidy `sorted/` tree plus `output/سجل-الترتيب.xlsx`.

> **Honesty note:** this template is **not "no-code"** — it has small **Code** nodes (read+classify, summary,
> build-log); the wiring, reading and writing are stock n8n nodes. n8n is **fair-code** (Sustainable Use License),
> **not** "open-source". The workflow **copies** files into `sorted/` and **leaves the originals in `downloads/`**,
> so it is safe to re-run. No AI model is used and nothing is uploaded. The files in `sample/` are SAMPLE DATA:
> invented names, no real people or organisation.

Adapt it:
- **New category** (e.g. bank statements): add a keyword in the «صنّف حسب النوع والتاريخ» node.
- **Sort by year instead of month:** use `iso.slice(0,4)` instead of `iso.slice(0,7)` in the folder name.
- **Move instead of copy:** after the write node, delete the original (or use `fs.renameSync` in one node) — once you trust it.
- **More image/doc types:** add the extension to the `IMG` or `DOC` lists in the classify node.

Built for Linux with self-hosted n8n. No AI model and no internet needed. Template files are under the MIT
licence (see LICENSE). n8n itself is fair-code (Sustainable Use License), **not** "open-source".
