# فواتير PDF ← جدول إكسل واحد (قالب n8n مجاني)
**Invoices PDF → one Excel sheet: free n8n template**

قالب مجاني من قناة «خلّيها على الـAI» على يوتيوب: https://www.youtube.com/@khallihaai

## الفكرة
يقرأ كل ملفات الفواتير (PDF) في مجلد، يستخرج النص، يلتقط رقم الفاتورة والتاريخ والمبلغ الإجمالي، ثم يكتبها كلها في
جدول إكسل واحد: `output/invoices.xlsx`. كل شيء يعمل على جهازك؛ لا يُرفع أي ملف إلى الإنترنت.

## الخطوات
1. ثبّت n8n على جهازك (مجاني للتشغيل الذاتي، برخصة fair-code). مثلاً: `npx n8n`
2. أنشئ مجلداً، وبداخله مجلدان: `invoices` (ضع فيه ملفات PDF) و`output`.
   للتجربة: انسخ فواتير `sample-invoices` (بيانات تجريبية) إلى `invoices`.
3. شغّل n8n **من داخل هذا المجلد** واسمح له بقراءة ملفاته:
   `cd my-invoices && N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n`
4. في n8n: استورد `workflow.json` (Import from file).
5. اضغط **Execute workflow**. الجدول يظهر في `output/invoices.xlsx`.

## عدّله لفواتيرك
القالب مضبوط على الفواتير التجريبية. عدّل التعابير الثلاثة في عقدة «Pull number / date / total» لتناسب فواتيرك:
- رقم الفاتورة: `INV-2026-\d{4}` → غيّره لنمط أرقام فواتيرك، مثلاً `(?:Invoice|فاتورة)\s*(?:No\.?|#|رقم)?\s*[:\-]?\s*([A-Z0-9\-]+)`
- التاريخ: `\d{4}-\d{2}-\d{2}` (سنة-شهر-يوم). لصيغة يوم/شهر/سنة استخدم `\d{2}/\d{2}/\d{4}`
- المبلغ: يبحث بعد «Grand Total» أو «Total Due» أو «Amount Due». أضف الكلمة المكتوبة في فواتيرك (مثلاً «الإجمالي»).

---

## English
Reads every PDF invoice in `invoices/`, extracts the text, pulls the invoice number, date and total, and writes them
all to one Excel sheet: `output/invoices.xlsx`. Runs fully on your own machine.

1. Install n8n (free to self-host, fair-code licence), e.g. `npx n8n`.
2. Make a folder with `invoices/` (your PDFs; try the `sample-invoices/` here first) and `output/`.
3. Start n8n **from that folder** and allow it to read the files:
   `cd my-invoices && N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n`
   (Docker: mount the folder at `/files`, set `N8N_RESTRICT_FILE_ACCESS_TO=/files`, and change the two file paths
   in the workflow to `/files/invoices/*.pdf` and `/files/output/invoices.xlsx`.)
4. Import `workflow.json`, then click **Execute workflow**.
5. Adapt the three expressions in "Pull number / date / total" to your invoices' wording (examples above).

Tested with self-hosted n8n 2.41 on Linux. The sample invoices are synthetic SAMPLE DATA: made-up companies and numbers.
The template files are under the MIT licence (see LICENSE). n8n itself has its own licence (Sustainable Use License).
