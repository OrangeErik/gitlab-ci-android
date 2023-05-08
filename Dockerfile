FROM ubuntu:22.04

# Global Gradle arguments
ARG GRADLE_VERSION="8.0"
ARG GRADLE_DIST=bin
ARG GRADLE_HOME="/gradle"
ARG GRADLE_PATH="${GRADLE_HOME}/gradle-${GRADLE_VERSION}/bin"

# Global Android command-line tools from https://developer.android.com/studio
ARG ANDROID_CMDLINE_TOOLS_VERSION=9477386
ENV ANDROID_SDK_ROOT "/sdk"
ENV ANDROID_HOME "/sdk"
ARG ANDROID_CMDLINE_TOOLS_BIN="${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin"

# Add Gradle and SDK tools to the PATH
ENV PATH "$PATH:${ANDROID_CMDLINE_TOOLS_BIN}/:${GRADLE_PATH}/:${ANDROID_HOME}/emulator/:${ANDROID_HOME}/platform-tools/:${ANDROID_HOME}/build-tools/33.0.0/"

# Setup distribution and install required distribution packages
ARG JDK_VERSION=17
ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --print-architecture && \
    dpkg --print-foreign-architectures

RUN dpkg --add-architecture i386 && \
    dpkg --print-foreign-architectures

RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
      curl \
      git-core \
      openjdk-${JDK_VERSION}-jdk \
      libc6-i386 \
      libstdc++6:i386 \
      zlib1g:i386 \
      unzip \
      make \
      locales \
      autoconf \
      automake \
      libtool \
      pkg-config \
      wget \
      gcc \
      libsonic-dev \
      libpcaudio-dev \
      zip

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8

RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Download and install SDK command-line tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip && \
    unzip *tools*linux*.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/tools && \
    rm *tools*linux*.zip

RUN yes | ${ANDROID_CMDLINE_TOOLS_BIN}/sdkmanager --licenses

RUN mkdir -p /root/.android \
 && touch /root/.android/repositories.cfg \
 && sdkmanager --verbose --update

ADD packages.txt /sdk
RUN sdkmanager --verbose --package_file=/sdk/packages.txt

# Download and install Gradle
# Keep it aligned default version as given in https://developer.android.com/studio/releases/gradle-plugin#versioning-update
RUN curl -s https://downloads.gradle-dn.com/distributions/gradle-${GRADLE_VERSION}-${GRADLE_DIST}.zip > /gradle.zip && \
    unzip -q /gradle.zip -d /gradle
