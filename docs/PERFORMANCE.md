# أداء الجهاز: إزاي نشغّل المشروع من غير ما الجهاز يهنّج

1. **حدّدي رام Docker** (أهم خطوة): ملف `C:\Users\<اسمك>\.wslconfig`
   ```
   [wsl2]
   memory=6GB
   processors=4
   swap=2GB
   ```
   ثم `wsl --shutdown` وأعيدي فتح Docker Desktop. (جهاز 8 جيجا: `memory=3GB` ولا تشغّلي إلا PostGIS.)
2. **شغّلي بس اللي محتاجاه.** الافتراضي PostGIS فقط. Airflow وحده يكفي معه. لا أكثر من 2–3 مجموعات.
3. **قفلي Docker Desktop لما تخلصي** (Quit من أيقونة الساعة). الرام بترجع فورًا.
4. **امنعيه من التشغيل مع الويندوز:** Docker Desktop ← Settings ← General ← ألغي «Start Docker Desktop when you sign in».
5. **فعّلي Resource Saver** في Settings لتقليل استهلاكه وهو فاضي.
6. **المتصفح والإضافات:** Chrome بتابات كتيرة وإضافات VS Code الزيادة بتاكل جيجات. اقفلي اللي مش محتاجاه.
7. **الشغل الثقيل** (ERA5 والصور) اشتغلي عليه على دفعات صغيرة (منطقة أو سنة)، واستخدمي Zarr/Dask.
8. **تنظيف آمن للمساحة:** `docker system df` يوريكي المستخدم، و`docker builder prune` يمسح كاش البناء فقط (مش بياناتك).
9. **مراقبة:** `docker stats` يوريكي استهلاك كل حاوية لحظيًا.
