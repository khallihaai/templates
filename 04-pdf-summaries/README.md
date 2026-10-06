# تلخيص تقارير PDF الطويلة في صفحة واحدة بالذكاء الاصطناعي المحلي (قالب n8n مجاني)
**Long PDF reports → one-page Arabic summaries, 100% local: free n8n template**

قالب مجاني من قناة «خلّيها على الـAI» على يوتيوب: https://www.youtube.com/@khallihaai

## الفكرة
يقرأ عدة تقارير بصيغة PDF من مجلد واحد، ويستخرج نصّها، ثم يرسل كل تقرير إلى نموذج ذكاء اصطناعي يعمل على جهازك
(Ollama + النموذج qwen3:8b)، فيكتب لكل تقرير ملخّصاً من صفحة واحدة بالعربية (ملخّص تنفيذي، ثم أهم النقاط، ثم
التوصيات)، ويحفظ كل ملخّص في ملف Markdown باسم تقريره: `output/<اسم التقرير>-ملخص.md`. كل شيء يعمل على جهازك،
مجاناً، ولا يُرفع أي ملف إلى الإنترنت.

## سير العمل
«عند الضغط على تنفيذ» ← «اقرأ ملفات التقارير» (`input/*.pdf`) ← «التقط اسم الملف» ← «استخرج نص الـPDF» ←
«البرومبت (التعليمات)» ← «لخّص بالذكاء الاصطناعي (Ollama)» ← «ابنِ الملخص (صفحة واحدة)» ← «احفظ كملف ماركداون» ←
«اكتب الملخص» (`output/<الاسم>-ملخص.md`). عقدة Ollama ترسل طلب POST إلى `http://localhost:11434/api/chat`.

## الخطوات
1. ثبّت n8n على جهازك (مجاني للتشغيل الذاتي، برخصة fair-code — Sustainable Use License). مثلاً: `npx n8n`
2. ثبّت Ollama (مجاني، يعمل محلياً)، ثم نزّل النموذج: `ollama pull qwen3:8b`. وتأكد أن `ollama serve` يعمل على `localhost:11434`.
3. أنشئ مجلداً، وبداخله مجلدان: `input` (ضع فيه ملفات تقاريرك PDF) و`output`.
   للتجربة: انسخ `sample/` (تقرير تجريبي) إلى `input/`.
4. شغّل n8n **من داخل هذا المجلد** واسمح له بقراءة ملفاته:
   `cd my-reports && N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n`
5. في n8n: استورد `workflow.json` (Import from file).
6. اضغط **Execute workflow**. ستجد ملخّصاً من صفحة واحدة لكل تقرير في مجلد `output`.

## عدّله لتقاريرك
- **غيّر النموذج:** في عقدة «لخّص بالذكاء الاصطناعي (Ollama)» بدّل `model: "qwen3:8b"` داخل الـ body بنموذج آخر يدعم العربية،
  وجرّبه أولاً على تقرير أو تقريرين. (في تجربتنا احترم `qwen3:8b` الإعداد `think:false` ولم يُظهر خطوات تفكيره.)
- **غيّر الأسلوب أو الطول:** عدّل التعليمات في عقدة «البرومبت (التعليمات)» (الحقل `system`)، مثل عدد النقاط أو إضافة قسم.
- **تقارير أطول:** الإعداد `num_ctx: 8192` يكفي لتقارير من بضع صفحات. للتقارير الأطول ارفعه (مع مراعاة ذاكرة كرت الشاشة)،
  والحقل `$json.text.slice(0, 6000)` في «البرومبت» يحدّد كم حرفاً من التقرير يُرسل؛ ارفعه إن احتجت.
- **أي نوع تقرير:** يعمل على التقارير المالية والتقنية والإدارية؛ بس ضع ملفاتك PDF في مجلد `input`.

> ملاحظة: النموذج يلخّص ما في التقرير فقط. راجع دائماً الملخّص قبل اعتماده، فالذكاء الاصطناعي قد يخطئ أحياناً في ربط رقم بسياقه.

---

## English
Reads several PDF reports from one folder, extracts their text, and sends each report to an AI model running on your
own machine (Ollama + qwen3:8b). For each report it writes a one-page Arabic summary (executive summary → key points →
recommendations) and saves it as a Markdown file named after the report: `output/<report name>-ملخص.md`. Runs fully on
your machine, free; nothing is uploaded.

1. Install n8n (free to self-host, fair-code licence — Sustainable Use License), e.g. `npx n8n`.
2. Install Ollama (free, local), then `ollama pull qwen3:8b`. Make sure `ollama serve` is running on `localhost:11434`.
3. Create a folder with `input` (your PDF reports) and `output` subfolders. To try it, copy `sample/` into `input/`.
4. Run n8n from inside that folder: `cd my-reports && N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n`.
5. In n8n, import `workflow.json` (Import from file).
6. Click **Execute workflow**. You'll get a one-page summary per report in `output/`.

**Tune it:** change `model` in the Ollama node; edit the instructions in the «البرومبت (التعليمات)» (prompt) node to
change length/sections; raise `num_ctx` and the `$json.text.slice(0, 6000)` cap for longer reports. Always review the
summary before relying on it. n8n is free to self-host under its own fair-code licence; this template is MIT-licensed.

*Sample files contain synthetic SAMPLE DATA only — no real company, person or figures.*
