# دليل العمل الجماعي — أطلس الطاقة المتجددة الحي لمصر

## قواعد ذهبية (3 بس)
1. **ما ترفعوش `.env` أبدًا.** فيه كلمات السر. كل واحد ينسخ `.env.example` إلى `.env`.
2. **أي مكتبة جديدة تنزّلها، ضيف اسمها في `environment.yml` في نفس اللحظة** (تحت `pip:` لو من pip). ده اللي بيخلي بيئات الكل متطابقة.
3. **ما نشتغلش على `main` مباشرة.** كل شغل في فرع، وبعدها Pull Request.

## الأوامر اليومية
```
git pull                                 # قبل ما تبدأ
git checkout -b feature/اسم-قصير         # فرع جديد لمهمتك
git add .  &&  git commit -m "وصف قصير"
git push -u origin feature/اسم-قصير      # وبعدها افتح Pull Request من GitHub
```
(أو من GitHub Desktop: Current Branch ← New Branch، ثم Commit، ثم Push origin، ثم Create Pull Request.)

## لما حد يغيّر `environment.yml`
بعد `git pull` نفّذ:  `conda env update -n egypt-energy -f environment.yml`
ولو تغيّر `web/package.json`:  `cd web ; npm install`

## قبل أي Pull Request
```
conda run -n egypt-energy pytest -q
conda run -n egypt-energy ruff check .
```
(الـ pre-commit بيشغّل ruff تلقائيًا عند كل commit بعد `setup\bootstrap.ps1`.)

## ترخيص المشروع
ما اتحددش بعد. ناقشوا الاختيار (مثلًا MIT) قبل النشر العلني، وراجعوا تراخيص البيانات في `docs/SPEC.md` القسم 17.
