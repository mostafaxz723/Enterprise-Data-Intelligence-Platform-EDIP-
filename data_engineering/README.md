# data_engineering — هندسة البيانات (الجزء الأساسي)
- `dags/` مهام Airflow (فيه `hello_world` للتأكد إن Airflow شغال).
- `ingestion/` سكربتات سحب البيانات (Open-Meteo، ERA5...) — المصادر في `docs/SPEC.md` القسم 6.
- `warehouse/` مشروع dbt: `models/staging` (تنظيف) و`models/analytics` (جداول نهائية). التشغيل: `docker compose run --rm dbt run`
- `config/` الإعدادات (`governorates.csv` مثال: إحداثيات تقريبية لعواصم المحافظات).
- `lake/` بيانات محلية (لا تُرفع إلى Git).
قاعدة البيانات: PostGIS على localhost:5433 (مخططات: raw / staging / analytics / chat).
