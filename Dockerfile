FROM python:3.8.1-alpine as base

ARG GITHUB_SHA
ARG GITHUB_WORKFLOW
ARG GITHUB_RUN_NUMBER
ARG GITHUB_ACTOR
ARG VERSION

LABEL org.opencontainers.image.authors="Prasad Tengse<tprasadtp@users.noreply.github.com>" \
      org.opencontainers.image.source="https://github.com/tprasadtp/sync-fork" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.licenses="MIT" \
      com.github.actions.actor="${GITHUB_ACTOR}" \
      com.github.actions.run="${GITHUB_RUN_NUMBER}" \
      com.github.actions.workflow="${GITHUB_WORKFLOW}" \
      com.github.commit.sha="${GITHUB_SHA}"

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

FROM base as user

RUN addgroup -g 1000 user \
    && adduser -G user -u 1000 -D -h /home/user -s /usr/bin/bash user \
    && mkdir -p /home/user/app \
    && chown -R 1000:1000 /home/user/app
USER user

# ENV stuff
WORKDIR /home/user/docs
ENV PATH "$PATH:/home/user/.local/bin"
