# جدول منتجات (إكسل) ← أوصاف تسويقية بالذكاء الاصطناعي المحلي (قالب n8n مجاني)
**Excel product list → AI marketing descriptions, 100% local: free n8n template**

قالب مجاني من قناة «خلّيها على الـAI» على يوتيوب: https://www.youtube.com/@khallihaai

## الفكرة
يقرأ جدول إكسل فيه منتجاتك بالأعمدة (الاسم / الفئة / المميزات / السعر)، ويرسل كل صف إلى نموذج ذكاء اصطناعي يعمل على
جهازك (Ollama + النموذج qwen3:8b)، فيكتب لكل منتج وصفاً تسويقياً قصيراً بالعربية ووصفاً آخر بالإنجليزية، ثم يحفظ الكل في
جدول إكسل جديد: `output/products-described.xlsx`. كل شيء يعمل على جهازك، مجاناً، ولا يُرفع أي ملف إلى الإنترنت.

## سير العمل
«عند الضغط على تنفيذ» ← «اقرأ ملف المنتجات» (`input/products.xlsx`) ← «استخرج صفوف الإكسل» ← «البرومبت (التعليمات)» ←
«الوصف بالعربية (Ollama)» ← «الوصف بالإنجليزية (Ollama)» ← «ادمج الوصف في صف» ← «ابنِ ملف إكسل» ← «احفظ الناتج»
(`output/products-described.xlsx`). كلتا عقدتَي Ollama ترسلان طلب POST إلى `http://localhost:11434/api/chat`.

## الخطوات
1. ثبّت n8n على جهازك (مجاني للتشغيل الذاتي، برخصة fair-code — Sustainable Use License). مثلاً: `npx n8n`
2. ثبّت Ollama (مجاني، يعمل محلياً)، ثم نزّل النموذج: `ollama pull qwen3:8b`. وتأكد أن `ollama serve` يعمل على `localhost:11434`.
3. أنشئ مجلداً، وبداخله مجلدان: `input` (ضع فيه ملف `products.xlsx`) و`output`.
   للتجربة: انسخ `sample/products.xlsx` (بيانات تجريبية) إلى `input/products.xlsx`.
4. شغّل n8n **من داخل هذا المجلد** واسمح له بقراءة ملفاته:
   `cd my-products && N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n`
5. في n8n: استورد `workflow.json` (Import from file).
6. اضغط **Execute workflow**. النتيجة في `output/products-described.xlsx` بعمودين جديدين: «الوصف (عربي)» وDescription (EN).

## عدّله لمنتجاتك
- **غيّر النموذج:** في عقدتَي الطلب «الوصف بالعربية (Ollama)» و«الوصف بالإنجليزية (Ollama)» بدّل `model: "qwen3:8b"` داخل الـ body بنموذج آخر يدعم العربية، وجرّبه أولاً على منتجين أو ثلاثة. (في تجربتنا تجاهل `qwen3:4b` الإعداد `think:false` وكتب خطوات تفكيره بدل الوصف.)
- **غيّر النبرة أو الطول:** عدّل التعليمات في عقدة «البرومبت (التعليمات)» (الحقل `system` للعربية، و`system_en` للإنجليزية).
- **استخدم جدولك أنت:** وجّه عقدة «اقرأ ملف المنتجات» إلى ملفك، بشرط أن تكون أعمدته: الاسم / الفئة / المميزات / السعر.
- **لا تريد الإنجليزية؟** احذف عقدة «الوصف بالإنجليزية (Ollama)»، وصِل «الوصف بالعربية (Ollama)» مباشرةً بـ«ادمج الوصف في صف»، ثم احذف حقل `Description (EN)` من عقدة «ادمج الوصف في صف» (وإلا امتلأ بالوصف العربي). أسرع أيضاً. أو ببساطة تجاهل العمود الإنجليزي دون أي تعديل.

---

## English
Reads an Excel sheet of your products (columns الاسم / الفئة / المميزات / السعر), sends each row to an AI model running
on your own machine (Ollama + qwen3:8b), and writes a new Excel sheet with a short Arabic marketing description per
product plus an English one: `output/products-described.xlsx`. Runs fully on your machine, free; nothing is uploaded.

1. Install n8n (free to self-host, fair-code licence — Sustainable Use License), e.g. `npx n8n`.
2. Install Ollama (free, local), then `ollama pull qwen3:8b`. Make sure `ollama serve` is running on `localhost:11434`.
3. Make a folder with `input/` (put your `products.xlsx` there; try `sample/products.xlsx` first) and `output/`.
4. Start n8n **from that folder** so it can read the files:
   `cd my-products && N8N_RESTRICT_FILE_ACCESS_TO="$PWD" npx n8n`
5. Import `workflow.json` (Import from file), then click **Execute workflow**.
6. The result appears in `output/products-described.xlsx` with two new columns: «الوصف (عربي)» and Description (EN).

Adapt it:
- **Model:** change `model: "qwen3:8b"` in the body of the two HTTP Request nodes to another model with good Arabic, and test it on 2–3 products first. (In our test `qwen3:4b` ignored `think:false` and returned its reasoning instead of a description.)
- **Tone / length:** edit the instructions in the «البرومبت (التعليمات)» node (`system` for Arabic, `system_en` for English).
- **Your own sheet:** point «اقرأ ملف المنتجات» at your file; keep the columns الاسم / الفئة / المميزات / السعر.
- **No English?** Delete the «الوصف بالإنجليزية (Ollama)» node, connect «الوصف بالعربية (Ollama)» straight to «ادمج الوصف في صف», and also delete the `Description (EN)` field in «ادمج الوصف في صف» (otherwise it fills with the Arabic text). Faster, too. Or just ignore the English column without changing anything.

Built for Linux with self-hosted n8n and Ollama running qwen3:8b. The sample products are SAMPLE DATA: invented brand names and prices.
The template files are under the MIT licence (see LICENSE). n8n itself is fair-code (Sustainable Use License), **not** "open-source".
The AI model qwen3:8b is Apache-2.0 (commercial use allowed). Everything runs on your own machine; nothing is uploaded.
