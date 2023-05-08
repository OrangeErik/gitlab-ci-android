# gitlab-ci-android

This Docker image is a fork of [jangrewe/gitlab-ci-android](https://github.com/jangrewe/gitlab-ci-android). This fork contains the Android SDK and most standard, up-to-date packages necessary for building Android apps in a CI in GitLab CI.

## Environment

- Ubuntu: `22.04`
- JDK: `17`
- Android command-line tools: `9477386`
- Android build tools & platform: `API 33`

## Building Apps

A `.gitlab-ci.yml` with caching of your project's dependencies would look like this:

```
image: theimpulson/gitlab-ci-android

stages:
- build

before_script:
- export GRADLE_USER_HOME=$(pwd)/.gradle
- chmod +x ./gradlew

build:
  stage: build
  script:
  - ./gradlew assembleDebug
  artifacts:
    paths:
    - app/build/outputs/apk/app-debug.apk
```

## Sources

You can find the source of this image at [GitLab](https://gitlab.com/theimpulson/gitlab-ci-android). This image is hosted on [DockerHub](https://hub.docker.com/r/theimpulson/gitlab-ci-android).

## Development

- A the list of contributors can be viewed on this repository's [contributors graph](https://gitlab.com/theimpulson/gitlab-ci-android/-/graphs/main).

In case you wish to contribute to the development of this project, feel free to open a [Merge Request](https://gitlab.com/theimpulson/gitlab-ci-android/-/merge_requests) or an [Issue](https://gitlab.com/theimpulson/gitlab-ci-android/-/issues/) for the same. Contributions are always welcome.
