# ابدئي من هنا (ويندوز) — خطوة بخطوة

لا تفهمي الأكواد دلوقتي. المطلوب بس تنفّذي الخطوات بالترتيب. كل خطوة جنبها **المفروض يحصل إيه**.

## 0) تأكدي من البرامج
افتحي PowerShell واكتبي:
```
git --version
node --version
docker --version
```
لازم يظهر رقم نسخة لكل واحد (Docker للدور data فقط). لو واحد مش موجود: [`setup/PROGRAMS.md`](setup/PROGRAMS.md).

## 1) انسخي الريبو (مرة واحدة)
**GitHub Desktop** ← File ← Clone repository ← تبويب URL، والصقي:
`https://github.com/mostafaxz723/Enterprise-Data-Intelligence-Platform-EDIP-.git`
وفي **Local path** اكتبي: `C:\Dev\Projects\egypt-energy` ثم Clone.
*(اسم المجلد على جهازك حر، مالوش علاقة باسم الريبو.)*

## 2) (لأول شخص فقط) انسخي ملفات الإعداد داخل المجلد
فكّي ملف `egypt-energy-setup.zip` في مجلد مؤقت `C:\Dev\Projects\_tmp`، ثم في PowerShell:
```
robocopy C:\Dev\Projects\_tmp C:\Dev\Projects\egypt-energy /E
```
المفروض يطلع جدول أرقام (أي رقم أقل من 8 يعني نجح). بعدها تقدري تمسحي `_tmp`.
**باقي الفريق يتخطى الخطوة دي**، لأن الملفات هتنزل معهم بـ git.

## 3) افتحي المشروع في VS Code
VS Code ← File ← Open Folder ← `C:\Dev\Projects\egypt-energy`.
المفروض تشوفي على الشمال: `web` و`data_engineering` و`engine` و`docker-compose.yml`...

## 4) (دور data فقط) أوقفي Docker القديم
```
cd C:\Dev\Infrastructure
docker compose --profile "*" down
cd C:\Dev\Projects\egypt-energy
```
(لو قال إن مفيش حاجة شغالة فتمام. الملف القديم يفضل كنسخة احتياطية.)

## 5) شغّلي التجهيز الشامل
في Terminal جوه VS Code (`` Ctrl+` ``)، اختاري **واحد** من الأوامر:
```
powershell -ExecutionPolicy Bypass -File setup\bootstrap.ps1 -Role web      # الواجهة فقط (جهاز ضعيف)
powershell -ExecutionPolicy Bypass -File setup\bootstrap.ps1 -Role data     # هندسة البيانات
powershell -ExecutionPolicy Bypass -File setup\bootstrap.ps1                # كل شيء
```
- أول مرة ياخد **15–40 دقيقة** (تنزيل مكتبات وصور Docker). سيبيه يخلص.
- مش بيمسح حاجة. بيضيف الناقص بس لبيئتك `egypt-energy`.
- في الآخر بيطبع فحص شامل. أي حاجة ناقصة بيكتب جنبها **الحل**. وآخر سطر المفروض: `EVERYTHING IS READY` (أو `WEB ROLE READY`).

## 6) اختاري Python interpreter (بعد ما التجهيز يخلص)
1. اضغطي `Ctrl+Shift+P` واكتبي **Python: Select Interpreter**.
2. اختاري الاسم اللي فيه **egypt-energy**.
3. لو مش ظاهر: اختاري **Enter interpreter path…** وألصقي:
   `C:\Users\LAPTOP\anaconda3\envs\egypt-energy\python.exe`
   (غيّري `LAPTOP` باسم المستخدم عندك.)
4. للـ Jupyter: ارفعي أي Notebook واختاري Kernel بنفس الاسم.

## 7) جرّبي إن كل حاجة شغالة
**الموقع** (أسهل اختبار):
```
cd web
npm run dev
```
افتحي http://localhost:3000 . المفروض تشوفي صفحة فيها مربع منقّط مكتوب فيه **TODO — شاشة فاضية**، وفوقها روابط باقي الشاشات. معناها إن الإعداد سليم.

**قاعدة البيانات والـ API** (دور data):
```
docker compose up -d
docker compose --profile app up -d
```
افتحي http://localhost:8000/health ، المفروض يظهر `{"status":"ok"}`.

**وقف كل حاجة لما تخلصي:**
```
.\setup\stack.ps1 stop
```

## 8) ارفعي الشغل (لأول شخص فقط)
GitHub Desktop هتلاقي الملفات في **Changes**. اكتبي رسالة `Add project setup` ← **Commit to main** ← **Push origin**.
بعدها باقي الفريق ينفّذ الخطوات 0 و1 و3 و5 و6 فقط.

## لو حصل مشكلة
| الرسالة / المشكلة | الحل |
|---|---|
| `running scripts is disabled` | استخدمي الأمر بالشكل اللي فيه `-ExecutionPolicy Bypass` زي فوق |
| `Docker engine not running` | افتحي Docker Desktop واستني `Engine running` |
| `port is already allocated` | في خدمة قديمة شاغلة المنفذ: نفّذي الخطوة 4 |
| `conda not found` | افتحي Anaconda Prompt بدل PowerShell، أو أعيدي تشغيل الجهاز بعد تركيب Anaconda |
| الجهاز بطيء | [`docs/PERFORMANCE.md`](docs/PERFORMANCE.md) |
| أي حاجة تانية | صوّري الشاشة كاملة وابعتيها |
