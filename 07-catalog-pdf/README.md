# من قائمة أسعار إكسل إلى كتالوج منتجات PDF جاهز للإرسال (قالب n8n مجاني)
**From one Excel price list to a ready-to-send product-catalogue PDF: free n8n template**

قالب مجاني من قناة «خلّيها على الـAI» على يوتيوب: https://www.youtube.com/@khallihaai

## الفكرة
عندك قائمة أسعار متجرك في ملف إكسل واحد، وتريد **كتالوجاً** مرتّباً ترسله على الواتساب أو تطبعه. هذا القالب
يقرأ قائمة الأسعار، ويرتّب المنتجات **حسب الفئة**، ويبني **ملف PDF واحداً** فيه **غلاف** باسم المتجر ثم **قسمٌ
لكل فئة** و**بطاقةٌ لكل منتج** باسمه ووصفه وسعره ووحدته. كل شيء يعمل على جهازك، مجاناً، **بدون أي ذكاء اصطناعي
وبدون إنترنت**.

## سير العمل
«عند الضغط على تنفيذ» ← «اقرأ قائمة الأسعار» (input/price-list.xlsx) ← «استخرج المنتجات» (صفوف الإكسل) ←
«ابنِ صفحة الكتالوج» (عقدة Code جاهزة ترتّب حسب الفئة وتبني صفحة HTML واحدة) ← «احفظ صفحة HTML»
(output/catalog.html) ← «أنشئ ملف الكتالوج PDF» (عقدة «أمر» تشغّل المتصفّح ليطبع الصفحة إلى
output/catalog.pdf) ← «اقرأ سجل الإنشاء» (output/render-log.csv) ← «استخرج السجل».

## لماذا عمود «الفئة»؟
لأن عقدة البناء تقرأ عمود «الفئة» لتقسّم الكتالوج إلى أقسام تلقائياً. ملف العيّنة في `sample/` يتبع هذا الشكل:
`الفئة | المنتج | وصف مختصر | السعر | الوحدة | الرمز`.

## الخطوات
1. ثبّت n8n على جهازك (مجاني للتشغيل الذاتي، برخصة fair-code — Sustainable Use License). مثلاً: `npx n8n`.
2. ثبّت متصفّحاً يطبع إلى PDF: **Chromium/Chrome** (الأفضل للتصميم)، أو **LibreOffice** كبديل. كلاهما مجاني.
3. أنشئ مجلداً، وبداخله: `input` (ضع فيه قائمة أسعارك) و`output` (فارغ). للتجربة: انسخ `sample/price-list.xlsx`
   إلى `input/`. وضع `render_catalog.sh` في هذا المجلد واجعله قابلاً للتنفيذ: `chmod +x render_catalog.sh`.
4. شغّل n8n **من داخل هذا المجلد**، واسمح له بقراءة ملفاته، وفعِّل عقدة «الأمر» (مُعطّلة افتراضياً في n8n v2):
   ```
   cd 07-catalog-pdf
   NODES_EXCLUDE="[]" N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n
   ```
5. في n8n: استورد `workflow.json` (Import from file)، ثم اضغط **Execute workflow**.
6. النتيجة في `output/catalog.pdf` — كتالوج بغلاف وأقسام وبطاقات أسعار. و`output/render-log.csv` يؤكد أنه خرج.

> **صدق مهم:** هذا القالب **ليس «بدون سطر برمجة»** — فيه عقدةٌ واحدة (Code) جاهزة تبني صفحة الكتالوج، وسطرٌ في
> عقدة «الأمر» يشغّل المتصفّح؛ أما القراءة والحفظ فبعقدات n8n الجاهزة. الكتالوج يحتاج متصفّحاً (Chromium أو
> LibreOffice) مثبّتاً على الجهاز. الأداة n8n **fair-code** (ليست «مفتوحة المصدر»). لا يُستخدم أي نموذج ذكاء
> اصطناعي، ولا يُرفع أي ملف إلى الإنترنت. البيانات في `sample/` تجريبية (أسماء متخيّلة، لا متجر ولا أشخاص حقيقيين).

## عدّله لك
- **صورة لكل منتج أو شعار متجرك على الغلاف:** أضف عمود صورة في قائمتك، وأدرِجه في عقدة «ابنِ صفحة الكتالوج».
- **ألوان متجرك:** غيّر ألوان الـCSS في عقدة البناء (اللون الذهبي والكحلي الحاليان مجرّد مثال).
- **عمود «الخصم» أو «السعر القديم»:** أضفه في ملفك، واعرضه في بطاقة المنتج.
- **كتالوج شهري أو موسمي:** بدّل محتوى `input/price-list.xlsx` وأعد التشغيل — كتالوج جديد في ثوانٍ.
- **استخدم بياناتك أنت:** صدّر قائمة أسعارك من نظامك إلى إكسل، واحرص أن تحمل عمود «الفئة» لكل منتج.

---

## English
You keep your shop's price list in one Excel file and want a tidy **catalogue** to send on chat or print. This
template reads the price list, groups the products **by category**, and builds **one PDF** with a **cover**, a
**section per category**, and a **card per product** (name, short description, price, unit). Runs fully on your
machine, free, **no AI and no internet**.

### Flow
Manual trigger → **Read File(s) From Disk** (`input/price-list.xlsx`) → **Extract From XLSX** (rows) → a small
**Code** node (groups by category and builds one catalogue HTML) → **Write File to Disk** (`output/catalog.html`)
→ **Execute Command** (`./render_catalog.sh` runs a headless browser that prints the page to
`output/catalog.pdf`) → **Read File** (`output/render-log.csv`) → **Extract From CSV**.

Each product row carries a **category** column so the catalogue groups itself into sections. The sample file in
`sample/` follows this shape: `category | product | short description | price | unit | code`.

### Steps
1. Install n8n (free to self-host, fair-code — Sustainable Use License), e.g. `npx n8n`.
2. Install a browser that prints to PDF: **Chromium/Chrome** (best layout fidelity) or **LibreOffice** (fallback).
3. Make a folder with `input/` (your price list) and `output/` (empty). To try it, copy `sample/price-list.xlsx`
   into `input/`. Put `render_catalog.sh` in this folder and `chmod +x render_catalog.sh`.
4. Start n8n **from that folder**, allowing file access and re-enabling the Execute Command node (disabled by
   default in n8n v2):
   ```
   cd 07-catalog-pdf
   NODES_EXCLUDE="[]" N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n
   ```
5. Import `workflow.json` (Import from file), then click **Execute workflow**.
6. The result is `output/catalog.pdf` (cover + category sections + price cards); `output/render-log.csv` confirms it.

> **Honesty note:** this template is **not "no-code"** — it has one small **Code** node (ready lines) that builds
> the catalogue page, and one line in the **Execute Command** node that runs the browser; the reading and saving are
> stock n8n nodes. It needs a browser/renderer (**Chromium** or **LibreOffice**) installed. n8n is **fair-code**
> (Sustainable Use License), **not** "open-source". No AI model, nothing uploaded. The files in `sample/` are
> SAMPLE DATA: invented names, no real shop or people.

Adapt it:
- **A product image or your shop logo on the cover:** add an image column and include it in the build node.
- **Your brand colours:** change the CSS colours in the build node (the current gold/navy are just an example).
- **A discount / old-price column:** add it to your file and show it on the product card.
- **Monthly / seasonal catalogue:** swap `input/price-list.xlsx` and re-run — a fresh catalogue in seconds.
- **Your own data:** export your price list to Excel; keep a **category** column on every product.

Built for Linux with self-hosted n8n + headless Chromium (LibreOffice fallback). No AI model and no internet needed.
The template files are under the MIT licence (see LICENSE). n8n itself is fair-code (Sustainable Use License),
**not** "open-source".
