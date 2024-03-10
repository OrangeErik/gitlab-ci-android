# gitlab-ci-android

This Docker image is a fork of [theimpulson/gitlab-ci-android]([https://github.com/jangrewe/gitlab-ci-android](https://gitlab.com/theimpulson/gitlab-ci-android)). This fork contains the Android SDK and most standard, up-to-date packages necessary for building Android apps in a CI in GitLab CI.

## Environment

- Ubuntu: `22.04`
- JDK: `17`
- Android command-line tools: `10406996`
- Android build tools & platform: `API 34`

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
