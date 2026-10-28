"""Verify every Python library and CLI tool the project needs. Run inside the env:
conda run -n egypt-energy python setup/check_python.py [--ai]
"""

import importlib.metadata as md
import importlib.util
import shutil
import sys

# (import name, conda/pip package name, installer)
LIBS = [
    ("geopandas", "geopandas", "conda"),
    ("pyogrio", "pyogrio", "conda"),
    ("fiona", "fiona", "conda"),
    ("shapely", "shapely", "conda"),
    ("pyproj", "pyproj", "conda"),
    ("rasterio", "rasterio", "conda"),
    ("rioxarray", "rioxarray", "conda"),
    ("rasterstats", "rasterstats", "conda"),
    ("regionmask", "regionmask", "conda"),
    ("h3", "h3-py", "conda"),
    ("osmnx", "osmnx", "conda"),
    ("geopy", "geopy", "conda"),
    ("contextily", "contextily", "conda"),
    ("mapclassify", "mapclassify", "conda"),
    ("cartopy", "cartopy", "conda"),
    ("leafmap", "leafmap", "conda"),
    ("geemap", "geemap", "conda"),
    ("pystac_client", "pystac-client", "conda"),
    ("xarray", "xarray", "conda"),
    ("netCDF4", "netcdf4", "conda"),
    ("h5netcdf", "h5netcdf", "conda"),
    ("cfgrib", "cfgrib", "conda"),
    ("dask", "dask", "conda"),
    ("zarr", "zarr", "conda"),
    ("pvlib", "pvlib-python", "conda"),
    ("pandas", "pandas", "conda"),
    ("numpy", "numpy", "conda"),
    ("scipy", "scipy", "conda"),
    ("polars", "polars", "conda"),
    ("duckdb", "duckdb", "conda"),
    ("pyarrow", "pyarrow", "conda"),
    ("sqlalchemy", "sqlalchemy", "conda"),
    ("psycopg2", "psycopg2", "conda"),
    ("geoalchemy2", "geoalchemy2", "conda"),
    ("alembic", "alembic", "conda"),
    ("pandera", "pandera", "conda"),
    ("yaml", "pyyaml", "conda"),
    ("requests", "requests", "conda"),
    ("requests_cache", "requests-cache", "conda"),
    ("httpx", "httpx", "conda"),
    ("tenacity", "tenacity", "conda"),
    ("dotenv", "python-dotenv", "conda"),
    ("loguru", "loguru", "conda"),
    ("rich", "rich", "conda"),
    ("typer", "typer", "conda"),
    ("sklearn", "scikit-learn", "conda"),
    ("statsmodels", "statsmodels", "conda"),
    ("xgboost", "xgboost", "conda"),
    ("lightgbm", "lightgbm", "conda"),
    ("shap", "shap", "conda"),
    ("optuna", "optuna", "conda"),
    ("mlflow", "mlflow", "conda"),
    ("matplotlib", "matplotlib", "conda"),
    ("seaborn", "seaborn", "conda"),
    ("plotly", "plotly", "conda"),
    ("altair", "altair", "conda"),
    ("pydeck", "pydeck", "conda"),
    ("streamlit", "streamlit", "conda"),
    ("fastapi", "fastapi", "conda"),
    ("uvicorn", "uvicorn", "conda"),
    ("pydantic", "pydantic", "conda"),
    ("orjson", "orjson", "conda"),
    ("redis", "redis-py", "conda"),
    ("boto3", "boto3", "conda"),
    ("s3fs", "s3fs", "conda"),
    ("jinja2", "jinja2", "conda"),
    ("networkx", "networkx", "conda"),
    ("rtree", "rtree", "conda"),
    ("openpyxl", "openpyxl", "conda"),
    ("reportlab", "reportlab", "conda"),
    ("pydantic_settings", "pydantic-settings", "conda"),
    ("numexpr", "numexpr", "conda"),
    ("bottleneck", "bottleneck", "conda"),
    ("tabulate", "tabulate", "conda"),
    ("folium", "folium", "conda"),
    ("jupyterlab", "jupyterlab", "conda"),
    ("pytest", "pytest", "conda"),
    ("windpowerlib", "windpowerlib", "pip"),
    ("openmeteo_requests", "openmeteo-requests", "pip"),
    ("retry_requests", "retry-requests", "pip"),
    ("cdsapi", "cdsapi", "pip"),
    ("ee", "earthengine-api", "pip"),
    ("planetary_computer", "planetary-computer", "pip"),
    ("odc.stac", "odc-stac", "pip"),
    ("pmtiles", "pmtiles", "pip"),
    ("arabic_reshaper", "arabic-reshaper", "pip"),
    ("bidi", "python-bidi", "pip"),
]
AI_LIBS = [
    ("torch", "torch", "pip"),
    ("sentence_transformers", "sentence-transformers", "pip"),
    ("openai", "openai", "pip"),
    ("anthropic", "anthropic", "pip"),
    ("pypdf", "pypdf", "pip"),
    ("pdfplumber", "pdfplumber", "pip"),
    ("rank_bm25", "rank-bm25", "pip"),
    ("tiktoken", "tiktoken", "pip"),
    ("psycopg2", "psycopg2", "conda"),
]
CLIS = [
    "gdalinfo",
    "ogr2ogr",
    "jupyter",
    "ruff",
    "black",
    "pytest",
    "uvicorn",
    "streamlit",
    "mlflow",
    "earthengine",
    "pre-commit",
]


def ver(dist):
    try:
        return md.version(dist)
    except Exception:
        return "?"


def main():
    libs = AI_LIBS if "--ai" in sys.argv else LIBS
    clis = [] if "--ai" in sys.argv else CLIS
    missing = {"conda": [], "pip": []}
    print(f"Python {sys.version.split()[0]}  |  {sys.executable}\n")
    for mod, pkg, how in libs:
        try:
            found = importlib.util.find_spec(mod) is not None
        except Exception:
            found = False
        if found:
            print(f"[OK]      {pkg:<24} {ver(pkg)}")
        else:
            print(f"[MISSING] {pkg:<24} ({how})")
            missing[how].append(pkg)
    for c in clis:
        print(f"[{'OK' if shutil.which(c) else 'MISSING'}]".ljust(10) + f" CLI: {c}")
    n = len(missing["conda"]) + len(missing["pip"])
    print(f"\n=== {len(libs)-n}/{len(libs)} libraries OK ===")
    if missing["conda"]:
        print("\nconda install -c conda-forge " + " ".join(missing["conda"]))
    if missing["pip"]:
        print("\npip install " + " ".join(missing["pip"]))
    sys.exit(1 if n else 0)


if __name__ == "__main__":
    main()
