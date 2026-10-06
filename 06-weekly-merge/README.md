# ادمج ٧ ملفات مبيعات يومية في ملخّص أسبوعي واحد ← ملف إكسل بتبويبَين (قالب n8n مجاني)
**Merge 7 daily sales Excel files into one weekly summary (two tabs): free n8n template**

قالب مجاني من قناة «خلّيها على الـAI» على يوتيوب: https://www.youtube.com/@khallihaai

## الفكرة
كل يومٍ تسجّل مبيعاتك في ملف إكسل. آخر الأسبوع عندك سبعة ملفات، وتريد تقريراً واحداً. هذا القالب يقرأ
**كل ملفات الإكسل في المجلد دفعةً واحدة**، ويدمجها في قائمةٍ واحدة، ثم يحسب **الإجمالي لكل يوم** و**الإجمالي
لكل منتج**، ويحفظ الكل في ملفٍ واحد: `output/weekly-summary.xlsx` فيه **تبويبان**: «البيانات الأسبوعية»
(كل الصفوف مدموجة) و«الملخص» (إجمالي كل يوم + إجمالي كل منتج + الإجمالي العام). كل شيء يعمل على جهازك، مجاناً،
**بدون أي ذكاء اصطناعي وبدون إنترنت**.

## سير العمل
«عند الضغط على تنفيذ» ← «اقرأ ملفات الأيام السبعة» (نمط `input/*.xlsx` يقرأ كل الملفات) ← «استخرج صفوف الإكسل»
(هنا يحدث الدمج: الملفات السبعة تصير قائمةً واحدة) ← يتفرّع إلى: «ملخص كل يوم» و«ملخص كل منتج» (عقدتا
Summarize تحسبان الإجماليات مباشرةً)، و«ابنِ التقرير الأسبوعي» (عقدة Code فيها بضعة أسطر جاهزة تبني ملف
الإكسل بتبويبَين) ← «احفظ الملف الأسبوعي» (`output/weekly-summary.xlsx`).

## لماذا تحمل كل ملفات الأيام عمودَي «التاريخ» و«اليوم»؟
حتى يعرف الملخّص — بعد الدمج — كلَّ صفٍّ لأي يوم. ملفات العيّنة في `sample/` تتبع هذا الشكل:
`التاريخ | اليوم | المنتج | الكمية | سعر الوحدة | الإجمالي`.

## الخطوات
1. ثبّت n8n على جهازك (مجاني للتشغيل الذاتي، برخصة fair-code — Sustainable Use License). مثلاً: `npx n8n`.
2. أنشئ مجلداً، وبداخله مجلدان: `input` (ضع فيه ملفاتك اليومية) و`output` (فارغ).
   للتجربة: انسخ ملفات `sample/` السبعة (بيانات تجريبية) إلى `input/`.
3. شغّل n8n **من داخل هذا المجلد**، واسمح له بقراءة ملفاته، واسمح لعقدة Code باستخدام مكتبة الإكسل المضمّنة في n8n:
   ```
   cd my-weekly
   N8N_RESTRICT_FILE_ACCESS_TO="$PWD" NODE_FUNCTION_ALLOW_EXTERNAL=@e965/xlsx npx n8n
   ```
   (`@e965/xlsx` هي مكتبة الجداول المضمّنة داخل n8n نفسه — لا تثبيت إضافي. عقدة Code تعمل عبر مشغّل المهام
   المدمج في n8n، وهو مُفعّل افتراضياً في الإصدارات الحديثة.)
4. في n8n: استورد `workflow.json` (Import from file).
5. اضغط **Execute workflow**. النتيجة في `output/weekly-summary.xlsx`: تبويب «البيانات الأسبوعية» وتبويب «الملخص».

> **صدق مهم:** هذا القالب **ليس «بدون سطر برمجة»** — فيه عقدةٌ واحدة (Code) بأسطرٍ جاهزة تبني ملف التبويبَين؛
> أما القراءة والدمج وحساب الإجماليات فتتم بعقدات n8n الجاهزة. الأداة n8n **fair-code** (ليست «مفتوحة المصدر»).
> كل شيء يعمل محلياً، ولا يُرفع أي ملف إلى الإنترنت. البيانات في `sample/` تجريبية (أسماء متخيّلة، لا أشخاص ولا محل حقيقي).

## عدّله لك
- **ملخّص شهري بدل أسبوعي:** ضع ٣٠ ملفاً — أو أي عدد — في `input/`؛ النمط `input/*.xlsx` يقرؤها كلّها. لا يتغيّر شيء.
- **أعمدة إضافية** (أرباح، متوسط سعر…): أضفها في ملفاتك، وعدّل أسطر عقدة «ابنِ التقرير الأسبوعي» لتُدرجها في التبويبَين.
- **فرّز حسب حقلٍ آخر** (الفرع، البائع…): بدّل حقل التقسيم في عقدتَي Summarize من «اليوم»/«المنتج» إلى حقلك.
- **استخدم بياناتك أنت:** صدّر مبيعات كل يوم من نظامك إلى ملف إكسل، واحرص أن يحمل عمودَي «التاريخ» و«اليوم».

---

## English
Each day you log your sales in an Excel file. By the end of the week you have seven files and want one report.
This template reads **every Excel file in a folder at once** (`input/*.xlsx`), merges them into a single list,
then computes **totals per day** and **totals per product**, and writes everything to one file:
`output/weekly-summary.xlsx` with **two tabs** — «البيانات الأسبوعية» (all merged rows) and «الملخص»
(per-day totals + per-product totals + grand total). Runs fully on your machine, free, **no AI and no internet**.

### Flow
Manual trigger → **Read File(s) From Disk** (`input/*.xlsx` reads all of them) → **Extract From XLSX**
(this is the merge: the seven files become one list) → fans out to: two **Summarize** nodes (totals per day
and per product, computed live) and a small **Code** node (a few ready lines that build the two-tab workbook with
n8n's bundled `@e965/xlsx`) → **Write File to Disk** (`output/weekly-summary.xlsx`).

Each daily file carries a **date** and **day** column so the merged rows still know which day each row belongs to.
The sample files in `sample/` follow this shape: `date | day | product | qty | unit price | total`.

### Steps
1. Install n8n (free to self-host, fair-code — Sustainable Use License), e.g. `npx n8n`.
2. Make a folder with `input/` (your daily files) and `output/` (empty). To try it, copy the seven `sample/`
   files (sample data) into `input/`.
3. Start n8n **from that folder**, allowing file access and letting the Code node use n8n's bundled Excel library:
   ```
   cd my-weekly
   N8N_RESTRICT_FILE_ACCESS_TO="$PWD" NODE_FUNCTION_ALLOW_EXTERNAL=@e965/xlsx npx n8n
   ```
   (`@e965/xlsx` is the spreadsheet library bundled inside n8n itself — no extra install. The Code node runs via
   n8n's built-in task runner, enabled by default in recent versions.)
4. Import `workflow.json` (Import from file), then click **Execute workflow**.
5. The result is `output/weekly-summary.xlsx` with a «البيانات الأسبوعية» tab and a «الملخص» tab.

> **Honesty note:** this template is **not "no-code"** — it has one small **Code** node (a few ready lines) that
> assembles the two-tab workbook; the reading, merging and totals are stock n8n nodes. n8n is **fair-code**
> (Sustainable Use License), **not** "open-source". Everything runs locally; nothing is uploaded. The files in
> `sample/` are SAMPLE DATA: invented names, no real people or shop.

Adapt it:
- **Monthly instead of weekly:** put 30 files (or any number) in `input/`; `input/*.xlsx` reads them all.
- **Extra columns** (profit, average price…): add them to your files and extend the «ابنِ التقرير الأسبوعي» node.
- **Group by another field** (branch, salesperson…): change the split field in the two Summarize nodes.
- **Your own data:** export each day's sales to an Excel file; keep a date and a day column in every file.

Built for Linux with self-hosted n8n. No AI model and no internet needed. The template files are under the MIT
licence (see LICENSE). n8n itself is fair-code (Sustainable Use License), **not** "open-source".
