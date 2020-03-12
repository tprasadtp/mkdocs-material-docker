# mkdocs-material docker image

[![actions](https://github.com/tprasadtp/mkdocs-material-docker/workflows/build/badge.svg)](https://github.com/tprasadtp/mkdocs-material-docker/actions?workflow=build)
[![actions](https://github.com/tprasadtp/mkdocs-material-docker/workflows/labels/badge.svg)](https://github.com/tprasadtp/mkdocs-material-docker/actions?workflow=labels)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/tprasadtp/mkdocs-material?logo=docker&label=latest&logoColor=white)](https://hub.docker.com/r/tprasadtp/mkdocs-material)
[![dependabot](https://api.dependabot.com/badges/status?host=github&repo=tprasadtp/mkdocs-material-docker)](https://app.dependabot.com)
![Analytics](https://ga-beacon.prasadt.com/UA-101760811-3/github/mkdocs-material-docker?pink&useReferer)

Images are published both on
  - [DockerHub](https://hub.docker.com/r/tprasadtp/mkdocs-material/tags) and ~~GitHub Package registry~~ [Waiting for  multi arch image support](https://github.community/t5/GitHub-API-Development-and/Handle-multi-arch-Docker-images-on-GitHub-Package-Registry/td-p/31650).
  - Version tag will always reflect version of `mkdocs-material` being used.

> It is recommended not to use `latest` tag as it may or may not track latest stable release.

## Notes

- Most of the work is done by bots and CI.
- Images are kept up to date by dependabot.
- This image adds following additional pip packages to the docker image
  ```text
  mkdocs-redirects
  mkdocs-minify-plugin
  mkdocs-git-revision-date-localized-plugin
  ```
- ARM64 and ARM7 images
- This image **DOES NOT** use upstream docker image as its base.
