# رتّب رسائل الزبائن تلقائياً (طلب / شكوى / سؤال) ← إكسل مصنّف بالذكاء الاصطناعي المحلي (قالب n8n مجاني)
**Sort customer messages (order / complaint / question) into a tidy Excel, 100% local: free n8n template**

قالب مجاني من قناة «خلّيها على الـAI» على يوتيوب: https://www.youtube.com/@khallihaai

## الفكرة
يقرأ جدول إكسل فيه رسائل زبائنك (عمود «الرسالة»)، ويرسل كل رسالة إلى نموذج ذكاء اصطناعي يعمل على جهازك
(Ollama + النموذج qwen3:8b)، فيصنّفها إلى: **طلب / شكوى / سؤال / أخرى**، ويضيف **درجة أولوية** (عاجل / عادي)،
ويكتب **رداً مقترحاً** مهذّباً. ثم يرتّب الكل حسب الفئة (العاجل أولاً) ويحفظه في جدول إكسل جديد:
`output/messages-sorted.xlsx`، مع عقدة تعدّ كم طلباً وكم شكوى وكم سؤالاً. كل شيء يعمل على جهازك، مجاناً،
ولا تُرفع أي رسالة إلى الإنترنت.

## سير العمل
«عند الضغط على تنفيذ» ← «اقرأ ملف الرسائل» (`input/messages.xlsx`) ← «استخرج صفوف الإكسل» ← «البرومبت (التعليمات)» ←
«صنّف الرسالة (Ollama)» ← «حلّل النتيجة» ← «رتّب حسب الفئة» ← «جهّز الأعمدة» ← «ابنِ ملف إكسل» ← «احفظ الناتج»
(`output/messages-sorted.xlsx`)، مع فرع «لخّص الأعداد» الذي يعدّ عدد كل فئة. عقدة Ollama ترسل طلب POST إلى
`http://localhost:11434/api/chat` بصيغة `format: json` فتعيد JSON فيه `category` و`urgency` و`reply`.

## الخطوات
1. ثبّت n8n على جهازك (مجاني للتشغيل الذاتي، برخصة fair-code — Sustainable Use License). مثلاً: `npx n8n`
2. ثبّت Ollama (مجاني، يعمل محلياً)، ثم نزّل النموذج: `ollama pull qwen3:8b`. وتأكد أن `ollama serve` يعمل على `localhost:11434`.
3. أنشئ مجلداً، وبداخله مجلدان: `input` (ضع فيه `messages.xlsx`) و`output`.
   للتجربة: انسخ `sample/messages.xlsx` (بيانات تجريبية) إلى `input/messages.xlsx`.
4. شغّل n8n **من داخل هذا المجلد** واسمح له بقراءة ملفاته:
   `cd my-messages && N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n`
5. في n8n: استورد `workflow.json` (Import from file).
6. اضغط **Execute workflow**. النتيجة في `output/messages-sorted.xlsx` مرتّبةً حسب الفئة، بأعمدة:
   «الرسالة» و«التصنيف» و«الأولوية» و«الرد المقترح».

> **صدق مهم:** الذكاء الاصطناعي **مساعد** للفرز، وليس بديلاً عن حكمك. في تجربتنا على ٢٥ رسالة تجريبية طابقَ
> التصنيف تصنيفَنا في ٢٣ منها (أكثر من ٩٠٪)، والباقي حالات حدّية تحتمل رأيين. **راجع التصنيف والردود قبل اعتمادها.**

## عدّله لك
- **غيّر الفئات:** في عقدة «البرومبت (التعليمات)» عدّل قائمة الفئات (مثلاً أضف «استرجاع» أو «متابعة شحنة»)،
  وحدّث خريطة الترتيب `cat_rank` في عقدة «حلّل النتيجة».
- **غيّر النموذج:** في عقدة «صنّف الرسالة (Ollama)» بدّل `model: "qwen3:8b"` داخل الـ body — مثلاً `qwen3:4b` لذاكرة أقل.
- **غيّر نبرة الرد:** عدّل تعليمات الرد في عقدة «البرومبت (التعليمات)» (الحقل `system`).
- **استخدم رسائلك أنت:** انسخ رسائل واتساب/إنستغرام في عمود «الرسالة» في `input/messages.xlsx` ثم نفّذ.

---

## English
Reads an Excel sheet of your customer messages (an «الرسالة» / message column), sends each message to an AI model
running on your own machine (Ollama + qwen3:8b), and classifies it into **order / complaint / question / other**, adds
an **urgency flag** (urgent / normal) and a short **polite reply suggestion**. It then sorts everything by category
(urgent first) and writes a new Excel sheet: `output/messages-sorted.xlsx`, plus a node that counts how many of each
category. Runs fully on your machine, free; nothing is uploaded.

1. Install n8n (free to self-host, fair-code licence — Sustainable Use License), e.g. `npx n8n`.
2. Install Ollama (free, local), then `ollama pull qwen3:8b`. Make sure `ollama serve` is running on `localhost:11434`.
3. Make a folder with `input/` (put your `messages.xlsx` there; try `sample/messages.xlsx` first) and `output/`.
4. Start n8n **from that folder** so it can read the files:
   `cd my-messages && N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n`
5. Import `workflow.json` (Import from file), then click **Execute workflow**.
6. The result appears in `output/messages-sorted.xlsx`, grouped by category, with columns: message, category, urgency,
   suggested reply.

> **Honesty note:** the AI is an **assistant** for triage, not a replacement for your judgement. On our 25 sample
> messages it matched our own labels on 23 (>90%); the rest were genuinely borderline. **Review the categories and
> replies before you rely on them.**

Adapt it:
- **Categories:** edit the list in the «البرومبت (التعليمات)» node (e.g. add "return" or "shipment tracking") and
  update the `cat_rank` map in the «حلّل النتيجة» node.
- **Model:** change `model: "qwen3:8b"` in the «صنّف الرسالة (Ollama)» node body — e.g. `qwen3:4b` for less RAM.
- **Reply tone:** edit the reply rules in the «البرومبت (التعليمات)» node (`system` field).
- **Your own messages:** paste WhatsApp/Instagram messages into the «الرسالة» column of `input/messages.xlsx`, then run.

Built for Linux with self-hosted n8n and Ollama running qwen3:8b. The sample messages are SAMPLE DATA: invented names,
no real people. The template files are under the MIT licence (see LICENSE). n8n itself is fair-code (Sustainable Use
License), **not** "open-source". The AI model qwen3:8b is Apache-2.0 (commercial use allowed). Everything runs on your
own machine; nothing is uploaded.
