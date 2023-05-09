# Copyright Aayush Gupta <aayushgupta219@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:22.04

# Global Android command-line tools from https://developer.android.com/studio
ARG ANDROID_CMDLINE_TOOLS_VERSION=9477386
ENV ANDROID_SDK_ROOT "/sdk"
ENV ANDROID_HOME "/sdk"
ARG ANDROID_CMDLINE_TOOLS_BIN="${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin"

# Add Gradle and SDK tools to the PATH
ENV PATH "$PATH:${ANDROID_CMDLINE_TOOLS_BIN}/:${ANDROID_HOME}/emulator/:${ANDROID_HOME}/platform-tools/:${ANDROID_HOME}/build-tools/30.0.3/"

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
