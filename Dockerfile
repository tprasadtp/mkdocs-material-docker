FROM python:3.8.2-alpine as base

# hadolint ignore=DL3018
RUN apk add --no-cache git
WORKDIR /docs
COPY requirements.txt requirements.txt
RUN pip install \
      --upgrade --progress-bar=off -U \
      --no-cache-dir \
      -r requirements.txt \
    && rm requirements.txt \
    && rm -rf /tmp/*.* /tmp/**/*.* /tmp/**/*
# Expose MkDocs development server port
EXPOSE 8000

# Start development server by default
ENTRYPOINT ["mkdocs"]

ARG VERSION
ENV VERSION="${VERSION}"
