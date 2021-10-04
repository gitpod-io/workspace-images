FROM gitpod/workspace-full

USER root
ARG SDK_VERSION=commandlinetools-linux-7302050_latest.zip
ARG ANDROID_BUILD_VERSION=30
ARG ANDROID_TOOLS_VERSION=30.0.3
ARG NDK_VERSION=21.4.7075529

# set default environment variables, please don't remove old env for compatibilty issue
ENV ADB_INSTALL_TIMEOUT=10
ENV ANDROID_HOME=/opt/android
ENV ANDROID_SDK_HOME=${ANDROID_HOME}
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}
ENV ANDROID_NDK=${ANDROID_HOME}/ndk/$NDK_VERSION
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

ENV PATH=${ANDROID_NDK}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${PATH}

# Android now only runs on jdk-8, jdk-11 is on the list
RUN apt update -qq && apt install -qq -y --no-install-recommends \
        ruby-dev \
        openjdk-8-jdk-headless \
        openjdk-11-jdk-headless \
    && gem install bundler \
    && rm -rf /var/lib/apt/lists/*;

# Full reference at https://dl.google.com/android/repository/repository2-1.xml
RUN curl -sS https://dl.google.com/android/repository/${SDK_VERSION} -o /tmp/sdk.zip \
    && mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && unzip -q -d ${ANDROID_HOME}/cmdline-tools /tmp/sdk.zip \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm /tmp/sdk.zip \
    && yes | sdkmanager --licenses \
    && yes | sdkmanager "platform-tools" \
        "emulator" \
        "platforms;android-$ANDROID_BUILD_VERSION" \
        "build-tools;$ANDROID_TOOLS_VERSION" \
        "cmake;3.18.1" \
        "system-images;android-21;google_apis;armeabi-v7a" \
        "ndk;$NDK_VERSION" \
    && rm -rf ${ANDROID_HOME}/.android

# fix permerssion issues for non-root user
RUN chmod 777 -R /opt/android

RUN npx envinfo