# إعداد الجهاز والحسابات المجانية

## 1) حدّي استهلاك رام Docker
أنشئي الملف `C:\Users\<اسمك>\.wslconfig`:
```
[wsl2]
memory=6GB
processors=4
swap=2GB
```
ثم: `wsl --shutdown` وأعيدي فتح Docker Desktop. (لو Airflow بيقع بـ "Killed" زوّدي إلى 8GB.)

## 2) الحسابات المجانية (ابدئي بها بدري لأن بعضها يأخذ أيامًا)
| الحساب | الاستخدام | الإعداد |
|---|---|---|
| GitHub | المستودع + Actions للجدولة والـ CI | gh auth login |
| Copernicus CDS | ERA5 | سجّلي ثم انسخي الـ Personal Access Token إلى `%USERPROFILE%\.cdsapirc`:<br>`url: https://cds.climate.copernicus.eu/api`<br>`key: <TOKEN>` |
| Copernicus ADS | غبار CAMS | نفس الفكرة بعنوان `https://ads.atmosphere.copernicus.eu/api` (مفتاحه من صفحة حسابك في ADS) |
| NASA Earthdata | أمطار IMERG | سجّلي ثم ملف `%USERPROFILE%\_netrc` |
| Google Earth Engine | معالجة أقمار | سجّلي مشروعًا غير تجاري ثم `earthengine authenticate` |
| Cloudflare | Pages + R2 + CDN | حساب مجاني |
| (اختياري) GitHub Student Pack | أرصدة سحابية ونطاق | لو أنتِ طالبة: education.github.com/pack **[تحقق من العروض الحالية]** |

> الأسرار تُكتب في `.env` أو ملفاتها الخاصة فقط، ولا تُرفع إلى GitHub أبدًا.

## 3) أدوات اختيارية لاحقًا
- **tippecanoe** (توليد الخرائط) — داخل WSL Ubuntu:
  `sudo apt update && sudo apt install -y build-essential libsqlite3-dev zlib1g-dev git && git clone https://github.com/felt/tippecanoe.git && cd tippecanoe && make -j && sudo make install`
- **pmtiles CLI**: ملف تنفيذي من صفحة إصدارات `protomaps/go-pmtiles` على GitHub.
- **نموذج محلي مجاني للشات بوت:** `ollama pull qwen2.5:3b` (جودة العربية محدودة؛ جرّبي أيضًا نماذج أكبر لو الجهاز يسمح).
