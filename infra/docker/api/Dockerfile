FROM python:3.11-slim
RUN pip install --no-cache-dir fastapi "uvicorn[standard]" psycopg2-binary sqlalchemy pydantic orjson httpx
WORKDIR /srv
