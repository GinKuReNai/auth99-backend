FROM python:3.11-buster as build

ENV PYTHONUNBUFFERED=1

WORKDIR /src

RUN pip install poetry

COPY pyproject.toml* poetry.lock* ./
COPY app /src/app
COPY .env /src/.env

RUN poetry config virtualenvs.create false
RUN if [ -f pyproject.toml ]; then poetry install --no-root ; fi

# ---------------------------------

FROM python:3.11-slim-buster as runtime

ENV PYTHONUNBUFFERED=1

WORKDIR /src

# ヘルスチェックのためのcurlをインストール
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl python3-pymysql

COPY --from=build /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /src /src

ENTRYPOINT [ "poetry", "run", "uvicorn", "app.main:app", "--reload", "--host", "0.0.0.0", "--port", "8000" ]
