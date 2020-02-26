#!/bin/bash

function cross_build()
{
  local TAG_PREFIX="${1}"
  local TAG="${2}"
  local PUSH_FLAG="${3:-true}"

  echo "IMAGE PREFIX: $TAG_PREFIX"
  echo "IMAGE TAG   : $TAG"
  echo "BRANCH      : $BRANCH"
  echo "PUSH_FLAG   : $PUSH_FLAG"

  if [[ -z ${TAG_PREFIX} ]] || [[ -z ${TAG} ]] || [[ -z ${BRANCH} ]] || [[ -z $PUSH_FLAG ]]  ; then
    echo "Error! Either TAG, TAG_PREFIX or BRANCH is empty"
    exit 2
  fi

  if [[ $PUSH_FLAG == "true" ]]; then
    echo "BUILDX :: Push is enabled!"
    DOCKER_BUILDKIT="${DOCKER_BUILDKIT}" docker buildx build \
        --platform linux/amd64,linux/arm64,linux/arm/v7 \
        --push \
        --target base \
        -t "${TAG_PREFIX}:${TAG}" \
        --build-arg GITHUB_ACTOR="${GITHUB_ACTOR}"\
        --build-arg GITHUB_SHA="${GITHUB_SHA}" \
        --build-arg GITHUB_WORKFLOW="${GITHUB_WORKFLOW}" \
        --build-arg GITHUB_RUN_NUMBER="${GITHUB_RUN_NUMBER}" \
        --build-arg VERSION="${VERSION}" \
        -f "${ROOT_DIR}/Dockerfile" \
        "${ROOT_DIR}"/
  else
    echo "BUILDX :: Push is Disabled!"
    DOCKER_BUILDKIT="${DOCKER_BUILDKIT}" docker buildx build \
        --platform linux/amd64,linux/arm64,linux/arm/v7 \
        --target base \
        -t "${TAG_PREFIX}:${TAG}" \
        --build-arg GITHUB_ACTOR="${GITHUB_ACTOR}"\
        --build-arg GITHUB_SHA="${GITHUB_SHA}" \
        --build-arg GITHUB_WORKFLOW="${GITHUB_WORKFLOW}" \
        --build-arg GITHUB_RUN_NUMBER="${GITHUB_RUN_NUMBER}" \
        --build-arg VERSION="${VERSION}" \
        -f "${ROOT_DIR}/Dockerfile" \
        "${ROOT_DIR}"/
  fi
}

function main()
{
  # Defaults
  enable_push="false"
  # Process command line arguments.
  while [ "$1" != "" ]; do
    case ${1} in
      -p | --push )     enable_push="true";
                        ;;
      * )               echo "Invalid arguments";
                        exit 1
                        ;;
    esac
    shift
  done

  if [[ ${BRANCH} == "master" ]]; then
    echo "Build LATEST"
    cross_build "${DOCKER_USER}/${NAME}" "latest" "$enable_push"
    # cross_build "${DOCKER_PREFIX_GITHUB}/${NAME}" "latest" "$enable_push"
    echo "Build LATEST-USER"
    cross_build "${DOCKER_USER}/${NAME}" "latest-user" "$enable_push"
    # cross_build "${DOCKER_PREFIX_GITHUB}/${NAME}" "latest-user" "$enable_push"
    echo "Build VERSION"
    cross_build "${DOCKER_USER}/${NAME}" "${VERSION}" "$enable_push"
    # cross_build "${DOCKER_PREFIX_GITHUB}/${NAME}" "${VERSION}" "$enable_push"
    echo "Build VERSION_USER"
    cross_build "${DOCKER_USER}/${NAME}" "${VERSION}-user" "$enable_push"
    # cross_build "${DOCKER_PREFIX_GITHUB}/${NAME}" "${VERSION}-user" "$enable_push"
  else
    echo "Build $BRANCH"
    cross_build "${DOCKER_USER}/${NAME}" "${BRANCH}" "$enable_push"
    # cross_build "${DOCKER_PREFIX_GITHUB}/${NAME}" "${BRANCH}" "$enable_push"
    echo "Build VERSION_USER"
    cross_build "${DOCKER_USER}/${NAME}" "${BRANCH}-user" "$enable_push"
    # cross_build "${DOCKER_PREFIX_GITHUB}/${NAME}" "${BRANCH}-user" "$enable_push"
  fi

}

main "$@"
