# التجهيز على Ubuntu (وDebian وMint)

> **تنبيه صريح:** دليل لينكس ده **مكتوب ولم يُجرَّب على جهاز Ubuntu حقيقي** لحد الآن (الفريق جرّب ويندوز). أول واحد يمشي عليه: لو أي خطوة فشلت، صوّر الشاشة وابعتها للفريق علشان نصلّح الدليل.
> الأوامر مكتوبة حسب **Ubuntu 22.04 أو 24.04** (جهاز Intel/AMD، أي x86_64). لو جهازك ARM اكتب لنا قبل ما تبدأ.

**الأوامر كلها** في **Terminal**: اضغط `Ctrl+Alt+T`. انسخ الأمر والصقه بـ `Ctrl+Shift+V`، واضغط Enter. أي أمر فيه `sudo` هيطلب **كلمة سر جهازك** (وانت بتكتبها مش هتظهر حروف، عادي، اكتبها واضغط Enter).

## 1) حدّد دورك
- رام **8 جيجا أو أقل:** دور `web`، تركّب بس **Git + VS Code + Node**.
- رام **16 جيجا:** دور `all`، تركّب كمان **Miniconda + Docker**.
(الجدول الكامل في [`README.md`](README.md).) اتأكد من رامك: `free -h` وبص على عمود **total**. والمساحة الفاضية: `df -h /` (محتاج 40 جيجا لدور `all`).

## 2) حدّث النظام وركّب الأساسيات
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget ca-certificates
```
**اتأكد:** `git --version` يطبع رقم نسخة.

## 3) عرّف Git باسمك (مرة واحدة)
```bash
git config --global user.name "اسمك الحقيقي"
git config --global user.email "إيميل-حساب-GitHub"
git config --global init.defaultBranch main
```

## 4) ركّب VS Code
```bash
sudo snap install --classic code
```
(لو مفيش snap، نزّل ملف `.deb` من `code.visualstudio.com` وركّبه من مدير البرامج.) **اتأكد:** `code --version`.

## 5) ركّب Node.js (لكل الأدوار)
نستخدم **nvm** علشان تاخد نسخة حديثة (نسخة Ubuntu القديمة بتعمل مشاكل):
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```
**اقفل Terminal وافتحه من جديد**، وبعدين:
```bash
nvm install --lts
node --version
npm --version
```
(رقم نسخة nvm في الأمر قد يتغير؛ لو فشل افتح صفحة `github.com/nvm-sh/nvm` وانسخ أمر التركيب الحالي منها.)

## 6) (دور `all` فقط) ركّب Miniconda
**Miniconda** هو نفس Anaconda بس أخف، والبيئة اللي بتتعمل **هي نفسها** (`egypt-energy`).
```bash
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init bash
```
**اقفل Terminal وافتحه**. المفروض يظهر `(base)` في أول السطر. **اتأكد:** `conda --version`. لو طلب منك conda موافقة على شروط الاستخدام (Terms of Service) اتبع الرسالة اللي بتظهر.

## 7) (دور `all` فقط) ركّب Docker
نستخدم **Docker Engine الرسمي** (مش نسخة Ubuntu القديمة):
```bash
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
```
**اعمل Log out ثم Log in** (أو أعد تشغيل الجهاز) علشان صلاحية Docker تشتغل. بعدين:
```bash
docker run hello-world
docker compose version
```
**المفروض** يطلع `Hello from Docker!` ورقم نسخة compose. (الأوامر دي من توثيق Docker الرسمي؛ لو اتغيّرت راجع `docs.docker.com/engine/install/ubuntu`.)
لينكس مفيهوش `.wslconfig`. حدود الذاكرة بتتحدد داخل ملف `docker-compose.yml` لكل خدمة، فمفيش حاجة تعملها.

## 8) حساب GitHub والدخول منه
1. اعمل حساب على `github.com` وابعت اسم المستخدم لمصطفى، وبعدها **اقبل الدعوة** من إيميلك (Invitation to collaborate).
2. ركّب **GitHub CLI** علشان تسجل دخول بسهولة:
```bash
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install -y gh
gh auth login
gh auth setup-git
```
في `gh auth login` اختار: **GitHub.com** ← **HTTPS** ← **Yes** (authenticate Git) ← **Login with a web browser**، وانسخ الكود اللي بيظهر وادخله في المتصفح.
**اتأكد:** `gh auth status` يقول `Logged in`.

## 9) نزّل المشروع
```bash
mkdir -p ~/projects && cd ~/projects
git clone https://github.com/mostafaxz723/Enterprise-Data-Intelligence-Platform-EDIP-.git egypt-energy-atlas
cd egypt-energy-atlas
ls
```
**المفروض** `ls` يعرض `README.md` و`docker-compose.yml` و`web` و`setup`. افتحه: `code .` (وافق على "Trust the authors").
أي أمر بعد كده اكتبه من **Terminal VS Code** (`` Ctrl+` ``) وهو جوه المجلد.

## 10) شغّل التجهيز التلقائي
```bash
bash setup/bootstrap.sh --role web     # جهاز 8 جيجا
bash setup/bootstrap.sh --role all     # جهاز 16 جيجا (conda + Docker + الموقع)
```
- **بياخد وقت** (45 دقيقة لساعتين لدور `all`). متقفلوش.
- **مش بيمسح حاجة.**
- **علامة النجاح:** في الآخر بيطبع فحص المكتبات `=== 87/87 libraries OK ===` ثم `Done.` (لدور `web` يخلص بـ `Done.`).
- لو قال `Missing: ...` ركّب الناقص من الخطوات فوق وأعد الأمر.

## 11) اختار الـ Python interpreter (دور `all`)
في VS Code: `Ctrl+Shift+P` ← **Python: Select Interpreter** ← اختار `egypt-energy`.
لو مش ظاهر: **Enter interpreter path…** وألصق `~/miniconda3/envs/egypt-energy/bin/python` (ممكن تحتاج المسار الكامل: `/home/<اسمك>/miniconda3/envs/egypt-energy/bin/python`).

## 12) جرّب إن كل حاجة شغّالة
```bash
cd web && npm run dev
```
افتح `http://localhost:3000`، المفروض تشوف **TODO — شاشة فاضية**. وقّفه بـ `Ctrl+C` وارجع `cd ..`.

دور `all`:
```bash
docker compose up -d
docker compose ps
docker compose --profile app up -d
curl http://localhost:8000/health
```
**المفروض** `egy_postgis_db` يبقى `healthy`، والـ curl يرجّع `{"status":"ok"}`.
وقف الخدمات لما تخلص:
```bash
docker compose --profile "*" stop
```
(سكربت `stack.ps1` مخصص لـ PowerShell فقط، في لينكس استخدم الأمر ده.)

## 13) خلصت؟
✅ اقرأ [`CONTRIBUTING.md`](../../CONTRIBUTING.md). وأوامر Git هناك نفسها في لينكس.

## مشاكل شائعة على لينكس
| المشكلة | الحل |
|---|---|
| `permission denied ... docker.sock` | ما عملتش Log out/in بعد `usermod -aG docker`. اعملها أو أعد التشغيل |
| `conda: command not found` | اقفل Terminal وافتحه، أو شغّل `~/miniconda3/bin/conda init bash` |
| `nvm: command not found` | اقفل Terminal وافتحه بعد تركيب nvm |
| `port is already allocated` | خدمة قديمة: `docker compose --profile "*" down` |
| `npm install` فشل بسبب الصلاحيات | متستخدمش `sudo npm`. تأكد إن Node جاي من nvm: `which node` يظهر مسار فيه `.nvm` |
| `bootstrap.sh: Permission denied` | استخدم `bash setup/bootstrap.sh` (مش `./`) |
| Docker بطيء/واخد رام | شغّل دور أخف أو `docker compose --profile "*" stop` لما تخلص |
