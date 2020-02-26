# mkdocs-material docker image

[![actions](https://github.com/tprasadtp/mkdocs-material-docker/workflows/build/badge.svg)](https://github.com/tprasadtp/mkdocs-material-docker/actions?workflow=build)
[![dependabot](https://api.dependabot.com/badges/status?host=github&repo=tprasadtp/mkdocs-material-docker)](https://app.dependabot.com)
![license](https://img.shields.io/github/license/tprasadtp/labels?color=orange)
![Analytics](https://ga-beacon.prasadt.com/UA-101760811-3/github/mkdocs-material-docker?pink&useReferer)

Images are published both on
  - [DockerHub](https://hub.docker.com/repository/docker/tprasadtp/mkdocs-material) and
  - GitHub Package registry
  - Version tag will always reflect version of `mkdocs-material`

## Notes

- Most of the work is done by bots and CI.
- Images are kept up to date by dependabot.

## Changes from upstream docker image

- This adds few more packages like `pygments` to the docker image.
- Also, docker image runs as a used with uid 1000 which might help with user namespaces.
- This image **DOES NOT** use upstream docker image as its base.
