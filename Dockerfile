FROM python:3.7-alpine

WORKDIR /app/
COPY pyproject.toml poetry.lock /app/

RUN \
  apk add --no-cache --virtual=.build-deps build-base curl gcc && \
  apk add --no-cache --virtual=.run-deps tini && \
  curl -O -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py && \
  python get-poetry.py --version=0.12.17 && \
  /root/.poetry/bin/poetry config settings.virtualenvs.create false && \
  /root/.poetry/bin/poetry install && \
  python get-poetry.py --uninstall && \
  apk del .build-deps

COPY . /app/

ARG commit_sha
ENV COMMIT_SHA=$commit_sha

USER root

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "gunicorn", "--bind=0.0.0.0", "--worker-class=aiohttp.GunicornWebWorker", "playground.base" ]

EXPOSE 8000
LABEL name=playground commit_sha=$commit_sha
