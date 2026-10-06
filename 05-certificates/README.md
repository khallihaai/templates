# اصنع ٥٠ شهادة PDF من قائمة إكسل تلقائياً ← شهادات مخصّصة بتصميم موحّد (قالب n8n مجاني)
**Generate 50 personalised PDF certificates from one Excel list, automatically: free n8n template**

قالب مجاني من قناة «خلّيها على الـAI» على يوتيوب: https://www.youtube.com/@khallihaai

## الفكرة
تدخل قائمة إكسل فيها أسماء المشاركين ودوراتهم وتواريخهم (أعمدة: **الاسم / الدورة / التاريخ**)، فتنشئ الأتمتة
**شهادة PDF مخصّصة لكل صف** من **قالب HTML واحد** صمّمته مرة واحدة (بألوانك وشعارك)، وتحفظها كلها في مجلد،
وتكتب **سجل إكسل** بكل شهادة أُنشئت. خمسون صفاً = خمسون شهادة، في ثوانٍ، بدون برامج تصميم وبدون أي سطر برمجة.

> **لا ذكاء اصطناعي هنا:** هذه **أتمتة** خالصة (قالب + دمج بيانات)، وليست توليداً بالذكاء الاصطناعي. الشهادات
> تُصنع من قالبك أنت، فتكون متطابقة ودقيقة في كل مرة.

## سير العمل
«عند الضغط على تنفيذ» ← «اقرأ قائمة المشاركين» (`input/participants.xlsx`) ← «استخرج الصفوف» ←
«املأ قالب الشهادة» (يضع الاسم والدورة والتاريخ ورقم الشهادة في القالب) ← «حوّل إلى صفحة HTML» ←
«احفظ صفحة الشهادة» (`output/html/cert-<رقم>.html`) ← «أنشئ ملفات PDF» (يشغّل `render_certs.sh` الذي يحوّل
كل صفحة إلى PDF عبر متصفّح Chromium) ← «اقرأ سجل التنفيذ» ← «استخرج السجل» ← «ادمج مع بيانات المشاركين» ←
«جهّز سجل الشهادات» ← «ابنِ ملف إكسل» ← «احفظ السجل» (`output/certificates-log.xlsx`).

النتيجة: مجلد `output/pdf/` فيه الشهادات، وملف `output/certificates-log.xlsx` بكل شهادة واسمها ورقمها وحالتها.

## الخطوات
1. ثبّت n8n على جهازك (مجاني للتشغيل الذاتي، برخصة fair-code — Sustainable Use License). مثلاً: `npx n8n`
2. ثبّت متصفّح **Chromium** (أو Google Chrome) — هو الذي يحوّل القالب إلى PDF بجودة عالية.
3. أنشئ مجلداً، وضع بداخله ملفات هذا القالب: `workflow.json` و`cert.css` و`render_certs.sh`، ومجلد `input/`
   (ضع فيه `participants.xlsx`) ومجلد `output/`. للتجربة: انسخ `sample/participants.xlsx` إلى `input/participants.xlsx`.
4. اجعل `render_certs.sh` قابلاً للتنفيذ: `chmod +x render_certs.sh`
5. شغّل n8n **من داخل هذا المجلد** مع تفعيل عقدة الأوامر والسماح له بقراءة ملفاته:
   `cd my-certs && NODES_EXCLUDE="[]" N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n`
   > n8n النسخة ٢ يعطّل عقدة **Execute Command** افتراضياً؛ `NODES_EXCLUDE="[]"` يعيد تفعيلها.
6. في n8n: استورد `workflow.json` (Import from file)، ثم اضغط **Execute workflow**.
7. الشهادات في `output/pdf/`، والسجل في `output/certificates-log.xlsx`.

## عدّله لك
- **غيّر التصميم:** كل تنسيق الشهادة في `cert.css` (الألوان، الإطار الذهبي، الخطوط، الشعار). غيّرها مرة،
  فتتغيّر كل الشهادات. والنصوص الثابتة (اسم المركز، «شهادة إتمام»…) في عقدة «املأ قالب الشهادة».
- **غيّر الأعمدة:** إن كانت قائمتك فيها أعمدة أخرى (مثل «الدرجة» أو «عدد الساعات»)، أضفها في عقدة
  «املأ قالب الشهادة» داخل قالب الـHTML، كما `{{ $json["الاسم"] }}`.
- **نوع الشهادة:** غيّر «شهادة إتمام» إلى «شهادة حضور» أو «شهادة تقدير» أو «خطاب شكر» في العقدة نفسها.
- **استخدم قائمتك أنت:** ضع أسماءك في `input/participants.xlsx` (عمود «الاسم» و«الدورة» و«التاريخ») ثم نفّذ.

---

## English
Feed in an Excel list of participants with their course and date (columns **name / course / date**), and the
automation builds **one personalised PDF certificate per row** from a single **HTML template** you design once
(your colours, your logo), saves them all to a folder, and writes an Excel **log** of every certificate created.
Fifty rows = fifty certificates, in seconds, with no design software and no code.

> **No AI here:** this is pure **automation** (a template + a data merge), not AI generation. The certificates are
> built from *your* template, so they are consistent and exact every time.

1. Install n8n (free to self-host, fair-code licence — Sustainable Use License), e.g. `npx n8n`.
2. Install **Chromium** (or Google Chrome) — it renders the template to a high-quality PDF.
3. Put this template's files in a folder: `workflow.json`, `cert.css`, `render_certs.sh`, plus `input/`
   (your `participants.xlsx`; try `sample/participants.xlsx` first) and an empty `output/` folder.
4. Make the renderer executable: `chmod +x render_certs.sh`.
5. Start n8n **from that folder**, enabling the command node and allowing file access:
   `cd my-certs && NODES_EXCLUDE="[]" N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n`
   > n8n v2 disables the **Execute Command** node by default; `NODES_EXCLUDE="[]"` re-enables it.
6. Import `workflow.json` (Import from file), then click **Execute workflow**.
7. Certificates land in `output/pdf/`; the log is `output/certificates-log.xlsx`.

Adapt it:
- **Design:** all styling lives in `cert.css` (colours, gold frame, fonts). Change it once — every certificate
  changes. Fixed text (centre name, "Certificate of Completion"…) is in the «املأ قالب الشهادة» node.
- **Columns:** add extra columns from your sheet into the HTML template in «املأ قالب الشهادة», like
  `{{ $json["الاسم"] }}`.
- **Certificate type:** change "شهادة إتمام" to attendance / appreciation / a thank-you letter in that node.
- **Your own list:** put your names in `input/participants.xlsx` (name / course / date), then run.

Built for Linux with self-hosted n8n and headless Chromium. **No Chromium?** `render_certs.sh` has a one-line
LibreOffice fallback (simpler design) documented at the bottom of the file. The sample participants are SAMPLE
DATA: invented names, no real people. The template files are under the MIT licence (see LICENSE). n8n itself is
fair-code (Sustainable Use License), **not** "open-source". Everything runs on your own machine; nothing is uploaded.
