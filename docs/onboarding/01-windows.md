# التجهيز على ويندوز (الخطوات كاملة)

**النظام:** ويندوز 10 أو 11 (64-bit). **كل الأوامر** بتتكتب في **PowerShell** (مش CMD). ولو معاك Virtual Machine لينكس، اشتغل هنا على ويندوز نفسه.

## 0) إزاي أفتح PowerShell؟
1. اضغط زرار **Windows** واكتب `PowerShell`.
2. اضغط Enter. هتفتح شاشة زرقا أو سودا فيها سطر بيخلص بـ `>` (اسمه الـ Terminal).
3. أي أمر في الدليل: **انسخه والصقه** (كليك يمين = لصق)، واضغط **Enter**.

> **قاعدة:** لو الأمر فيه مكان عليك تغيّره، هكتبه بين علامتين مثل `<اسمك>`. غيّره بقيمتك وامسح العلامتين.

## 1) اتأكد إن جهازك يصلح (دقيقتين)
- **الديسك:** ادخل **This PC** وشوف المساحة الفاضية. محتاج **40 جيجا** لدور `all` أو **5 جيجا** لدور `web`.
- **الـ Virtualization** (لدور `all` فقط، علشان Docker): `Ctrl+Shift+Esc` ← **Performance** ← **CPU**، وتحت لازم تلاقي **Virtualization: Enabled**. لو `Disabled` يبقى لازم تفعّلها من إعدادات BIOS (ابحث على النت باسم موديل جهازك + "enable virtualization")، وبلّغ الفريق لو علقت.

## 2) ركّب البرامج
**الأسهل:** أمر واحد لكل برنامج في PowerShell (ويندوز 11 فيه `winget` جاهز). **لو الأمر قال إنه مش لاقي حاجة**، نزّل البرنامج من موقعه الرسمي (الموقع جنب كل واحد).

### لكل الأدوار (web و all)
```powershell
winget install --id Git.Git -e
winget install --id Microsoft.VisualStudioCode -e
winget install --id OpenJS.NodeJS.LTS -e
```
- **Git** (`git-scm.com`): برنامج بيحفظ نسخ مشروعك وبيخليكم تشتغلوا مع بعض.
- **VS Code** (`code.visualstudio.com`): المحرر اللي هنكتب فيه.
- **Node.js LTS** (`nodejs.org`): بيشغّل الموقع.

### لدور `all` فقط (جهاز 16 جيجا)
```powershell
winget install --id Anaconda.Anaconda3 -e
winget install --id Docker.DockerDesktop -e
```
- **Anaconda** (`anaconda.com/download`): بيعمل بيئات Python معزولة (هنشرحها بعدين).
- **Docker Desktop** (`docker.com`): بيشغّل قواعد البيانات والخدمات من غير ما تركّبها بإيدك. بعد التركيب **ممكن يطلب Restart للجهاز**، وافق.

### اختياري
QGIS (`qgis.org`) لمراجعة الخرائط، و GitHub Desktop (`desktop.github.com`) لو تفضل واجهة بدل أوامر Git.

### 3) **اقفل PowerShell وافتحه من جديد** (مهم)
علشان الويندوز يشوف البرامج اللي لسه مركّبها. بعدين اتأكد:
```powershell
git --version
node --version
npm --version
```
**المفروض** يطلع رقم نسخة لكل واحد (مثلًا `git version 2.xx`، `v22...`). لو واحد طلع `is not recognized` يبقى التركيب ما اتمش، أعده.

لدور `all` كمان:
```powershell
docker --version
& "$env:USERPROFILE\anaconda3\Scripts\conda.exe" --version
```
(لو Anaconda مش في المسار ده، دوّر عليها في قايمة Start باسم **Anaconda Prompt**.)

**لدور `all`: افتح Docker Desktop** من قايمة Start، ووافق على الشروط، واستنى لحد ما تحت على الشمال يظهر **Engine running** (أخضر). تقدر تتخطى تسجيل الدخول (Skip).

## 4) عرّف Git باسمك (مرة واحدة لو لسه أول مرة هتستخدمه)
```powershell
git config --global user.name "اسمك الحقيقي"
git config --global user.email "إيميل-حساب-GitHub"
```
**ليه؟** كل تعديل بتعمله بيتسجّل باسمك. استخدم **نفس الإيميل** اللي عامل بيه حساب GitHub.
اتأكد: `git config --global user.name` بيطبع اسمك.

## 5) نزّل المشروع (Clone)
```powershell
mkdir C:\Dev\Projects -Force
cd C:\Dev\Projects
git clone https://github.com/mostafaxz723/Enterprise-Data-Intelligence-Platform-EDIP-.git egypt-energy-atlas
cd egypt-energy-atlas
```
- أول سطر بيعمل مجلد `C:\Dev\Projects` لو مش موجود.
- `git clone` بينسخ المشروع كله على جهازك في مجلد اسمه `egypt-energy-atlas`.
- **أول مرة هيفتح لك متصفح** تسجّل دخول GitHub. وافق. لو طلع `Repository not found` أو `403` يبقى لسه ما قبلتش دعوة الـ Collaborator (الخطوة 4 في الصفحة الرئيسية للدليل).
- **اتأكد إنك في المجلد الصح:** اكتب `dir` المفروض تشوف `README.md` و`docker-compose.yml` و`web` و`setup`.

> **خليك مستخدم نفس اسم ومكان المجلد (`C:\Dev\Projects\egypt-energy-atlas`)** علشان أي أمر في الدليل يشتغل عندك زي عند الباقي.

## 6) افتح المشروع في VS Code
```powershell
code .
```
(النقطة معناها "المجلد ده".) لو VS Code سألك **"Do you trust the authors?"** اختار **Yes**. وافق على اقتراح تركيب الإضافات (Recommended extensions).

افتح Terminal جوه VS Code: `` Ctrl+` `` (الزرار فوق Tab). هيفتح تحت وهو بالفعل جوه مجلد المشروع. **من هنا كل الأوامر تكتبها فيه.**

## 7) شغّل التجهيز التلقائي

### جهاز 8 جيجا (أو أقل): دور `web`
```powershell
powershell -ExecutionPolicy Bypass -File setup\bootstrap.ps1 -Role web
```
### جهاز 16 جيجا: دور `all`
**أولًا حدّد رام Docker** (مرة واحدة)، علشان جهازك ما يهنّجش:
```powershell
@"
[wsl2]
memory=6GB
processors=4
swap=2GB
"@ | Set-Content -Encoding ascii "$env:USERPROFILE\.wslconfig"
wsl --shutdown
```
وبعدين افتح Docker Desktop تاني واستنى **Engine running**، وشغّل:
```powershell
powershell -ExecutionPolicy Bypass -File setup\bootstrap.ps1
```

**الأمر ده بيعمل إيه:** بيجهّز بيئة Python، وبيحمّل صور Docker (من غير ما يشغّلها)، وبيركّب مكتبات الموقع، وفي الآخر بيعمل فحص شامل.
- **بياخد وقت** (انظر الجدول في الصفحة الرئيسية)، وهيطبع أسطر كتير وساعات يبان إنه واقف. **متقفلوش.**
- **مش بيمسح حاجة** من جهازك.
- **علامة النجاح:** آخر سطر `EVERYTHING IS READY` (لدور `all`) أو `WEB ROLE READY` (لدور `web`).
- لو ظهرت سطور فيها `[MISSING]` اقرأ جنبها كلمة `fix:` وطبّقها، وشغّل نفس الأمر تاني. لو علقت، ابعت صورة الشاشة للفريق.

**لماذا بيئة conda؟** تخيّل صندوق أدوات جاهز اسمه `egypt-energy` فيه كل مكتبات المشروع بنفس النسخ عند الكل. ومفيش حاجة منه بتتلخبط مع باقي برامجك.

## 8) اختار الـ Python interpreter (لدور `all`)
في VS Code: `Ctrl+Shift+P` ← اكتب **Python: Select Interpreter** ← اختار اللي فيه **egypt-energy**.
لو مش ظاهر: **Enter interpreter path…** وألصق: `C:\Users\<اسمك-على-الجهاز>\anaconda3\envs\egypt-energy\python.exe`.
**اتأكد:** تحت يمين في VS Code بتظهر `3.11 ('egypt-energy')`.

## 9) جرّب إن كل حاجة شغّالة

### الموقع (كل الأدوار)
```powershell
cd web
npm run dev
```
افتح المتصفح على `http://localhost:3000`. **المفروض** تشوف صفحة فيها مربع منقّط مكتوب فيه **TODO — شاشة فاضية** وروابط الشاشات فوق. لو شفتها يبقى إعدادك سليم. وقّفه بـ `Ctrl+C`، وارجع بـ `cd ..`.

### قاعدة البيانات والـ API (دور `all`)
```powershell
docker compose up -d
docker compose ps
```
**المفروض** تلاقي `egy_postgis_db` وحالته `healthy` (استنى نص دقيقة لو لسه `starting`). وبعدين:
```powershell
docker compose --profile app up -d
```
افتح `http://localhost:8000/health` المفروض يظهر `{"status":"ok"}`.

### اقفل كل حاجة لما تخلص (علشان جهازك يرتاح)
```powershell
.\setup\stack.ps1 stop
```
وبعدها تقدر تقفل Docker Desktop (Quit من أيقونته جنب الساعة).

## 10) خلصت التجهيز؟
✅ اقرأ [`CONTRIBUTING.md`](../../CONTRIBUTING.md) قبل ما تلمس أي ملف.

## مشاكل شائعة على ويندوز

| المشكلة | السبب | الحل |
|---|---|---|
| `running scripts is disabled` | سياسة الأمان | استخدم الأمر بالشكل اللي فيه `-ExecutionPolicy Bypass` |
| `'git' is not recognized` | PowerShell فاتح قبل التركيب | اقفله وافتحه، أو أعد تركيب Git |
| Docker: `error during connect` أو `engine not running` | Docker Desktop مش شغّال | افتحه واستنى **Engine running** |
| `port is already allocated` | برنامج تاني شاغل المنفذ | أوقف الخدمة القديمة: `.\setup\stack.ps1 stop` |
| `Virtualization is disabled` | مفعّلة في BIOS | فعّلها من BIOS |
| الجهاز بطيء جدًا | Docker واخد رام كتير | تأكد من ملف `.wslconfig` (الخطوة 7) وشغّل دور `web` فقط |
| `Repository not found` عند clone | ما قبلتش دعوة الـ Collaborator | ادخل إيميلك وقبل الدعوة |
| تحذيرات `LF will be replaced by CRLF` | فرق شكل الأسطر بين ويندوز ولينكس | **تجاهلها**، مش مشكلة |
| `npm install` بياخد وقت طويل (حتى 6 دقايق) | عادي، مكتبات كتير | استنى |
