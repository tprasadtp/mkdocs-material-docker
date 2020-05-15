FROM python:3.8.3-alpine as base

FROM base as builder

WORKDIR /docs

COPY requirements.txt requirements.txt

RUN pip install \
      --upgrade \
      --progress-bar=off -U \
      --no-cache-dir \
      --prefix /install \
      --requirement requirements.txt

# Release Image
FROM base as release

# hadolint ignore=DL3018
RUN apk add --no-cache git

COPY --from=builder /install /usr/local

# Expose MkDocs development server port
EXPOSE 8000

ARG VERSION
ENV VERSION="${VERSION}"

# Start development server by default
ENTRYPOINT ["mkdocs"]
