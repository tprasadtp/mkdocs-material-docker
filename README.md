# mkdocs-material docker image

[![actions](https://github.com/tprasadtp/mkdocs-material-docker/workflows/build/badge.svg)](https://github.com/tprasadtp/mkdocs-material-docker/actions?workflow=build)
[![dependabot](https://api.dependabot.com/badges/status?host=github&repo=tprasadtp/mkdocs-material-docker)](https://app.dependabot.com)
[![](https://images.microbadger.com/badges/version/tprasadtp/mkdocs-material.svg)](https://hub.docker.com/repository/docker/tprasadtp/mkdocs-material)
![Analytics](https://ga-beacon.prasadt.com/UA-101760811-3/github/mkdocs-material-docker?pink&useReferer)

Images are published both on
  - [DockerHub](https://hub.docker.com/repository/docker/tprasadtp/mkdocs-material) and
  - GitHub Package registry
  - Version tag will always reflect version of `mkdocs-material` being used.

## Notes

- Most of the work is done by bots and CI.
- Images are kept up to date by dependabot.
- This image adds following additional pip packages to the docker image
  ```text
  mkdocs-redirects
  mkdocs-minify-plugin
  mkdocs-git-revision-date-localized-plugin
  mknotebooks
  ```
- Also, docker image runs as a user with uid 1000 which might help with user namespaces.
- This image **DOES NOT** use upstream docker image as its base.
