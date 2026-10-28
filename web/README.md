# web — الموقع (Next.js)
الإعداد جاهز (مكتبات الخرائط والـ 3D متثبتة). الشاشات هنا **ملفات فاضية فيها عنوان ووظيفة كل شاشة**، وانتو تكتبوا محتواها.
تشغيل: `npm install` ثم `npm run dev` → http://localhost:3000   ·   للنشر المجاني: `npm run build` ينتج مجلد `out/`.

| المسار | الملف | الوظيفة | مكتبات مقترحة |
|---|---|---|---|
| `/` | `app/page.tsx` | الرئيسية: الأسئلة الثلاثة + المميزات | — |
| `/map` | `app/map/page.tsx` | خريطة المواقع (H3 ثلاثية الأبعاد) + أوزان | maplibre-gl, deck.gl |
| `/site` | `app/site/page.tsx` | صفحة موقع: الإنتاج، التكلفة، «لماذا؟» | — |
| `/compare` | `app/compare/page.tsx` | مقارنة 2–4 مواقع | — |
| `/forecast` | `app/forecast/page.tsx` | توقع 72 ساعة + تنبيهات الغبار | رسوم (SVG/Recharts) |
| `/simulator` | `app/simulator/page.tsx` | محاكي 3D للمحطة (شمس/رياح/غبار) | three, @react-three/fiber |
| `/assistant` | `app/assistant/page.tsx` | الشات بوت | — |
| `/methodology` | `app/methodology/page.tsx` | المعادلات والمصادر والحدود | — |

مجلدات: `components/` مكونات مشتركة · `lib/` دوال وأنواع · `public/data/` بيانات JSON ساكنة للموقع.
