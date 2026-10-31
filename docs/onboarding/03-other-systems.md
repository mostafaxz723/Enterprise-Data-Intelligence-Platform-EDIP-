# أنظمة تانية: Red Hat وFedora وVirtual Machine وmacOS

> **تنبيه صريح:** الأنظمة دي **لم تُجرَّب** مع المشروع. الدليل معمول على أساس إنها شغالة بنفس الأدوات، لكن ما اختبرناهاش. التوصية الأولى لأي حد معاه ويندوز: **اشتغل على ويندوز**.

## 1) معاك Virtual Machine (Red Hat أو غيره) على ويندوز
**اشتغل على ويندوز نفسه ومتستخدمش الـ VM لمشروعنا.** الأسباب:
- Docker جوه VM بيحتاج virtualization متداخلة (Nested) وبياكل رام مضاعف.
- Red Hat بيجي بـ **Podman** بدل Docker، وملف `docker-compose.yml` عندنا **متجرّبش** معاه.
- مفيش حاجة في المشروع محتاجة لينكس.

يعني امشي على [`01-windows.md`](01-windows.md). والـ VM سيبه لتعلّم لينكس.

## 2) لينكس مركّب جنب ويندوز (Dual boot) بس ما استخدمتوش
نفس الكلام: اشتغل على **ويندوز** ([`01-windows.md`](01-windows.md)). ولو عايز تتعلم لينكس بشكل تدريجي، ابدأ بـ [`02-ubuntu-linux.md`](02-ubuntu-linux.md) في وقت فاضي.

## 3) Red Hat / Rocky / Alma / Fedora كنظام أساسي
**الاقتراح:** اشتغل بدور `web` (الموقع) + Miniconda للأدوات، وسيب Docker لمن معاه ويندوز أو Ubuntu.
```bash
sudo dnf install -y git curl wget
git config --global user.name "اسمك"
git config --global user.email "إيميل-GitHub"
```
- **Node.js:** استخدم **nvm** (نفس خطوة Ubuntu رقم 5).
- **Miniconda:** نفس خطوة Ubuntu رقم 6 (مش بيعتمد على التوزيعة).
- **GitHub CLI:** `sudo dnf install gh` (أو اتبع `cli.github.com/packages` لإضافة المستودع الرسمي).
- **Docker:** Red Hat بيستخدم **Podman**. لو عايز تجرّب: `sudo dnf install -y podman podman-compose`، وبدّل `docker compose` بـ `podman-compose` (أو `podman compose`). **غير مضمون** لأن ملفنا بيعتمد على ميزات Compose معينة (profiles و`depends_on` بشروط). لو نجح أو فشل، بلّغ الفريق بالنتيجة.
- بعد كده كمّل من خطوة 9 في [`02-ubuntu-linux.md`](02-ubuntu-linux.md) (النسخ والتشغيل زي بعض): `bash setup/bootstrap.sh --role web`.

## 4) macOS
ركّب [Homebrew](https://brew.sh) أولًا، وبعدين:
```bash
brew install git node gh
brew install --cask visual-studio-code docker miniconda
```
افتح Docker Desktop مرة، واتأكد إن Terminal بيشوف conda (`conda init zsh` ثم أعد فتح Terminal). بعدها كمّل من خطوة 9 في [`02-ubuntu-linux.md`](02-ubuntu-linux.md):
```bash
bash setup/bootstrap.sh --role all
```
على ماك بمعالج Apple Silicon ممكن بعض صور Docker (مثلًا Airflow) تشتغل ببطء أو تحتاج إعداد منصة. بلّغ الفريق لو ظهر خطأ.

## 5) لو مش عايز تركّب أي حاجة محليًا (حل احتياطي)
- **GitHub Codespaces** (على GitHub: زرار **Code ← Codespaces**) بيفتح VS Code على الإنترنت جاهز. فيه حصة مجانية شهرية محدودة **[تحقق من الحد الحالي]**، وبيناسب كتابة الكود والواجهة أكتر من تشغيل كل خدمات Docker.
