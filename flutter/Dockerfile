FROM gitpod/workspace-dart-vnc

ENV ANDROID_HOME=/home/gitpod/android-sdk-linux \
    FLUTTER_HOME=/home/gitpod/flutter \
    PATH=$FLUTTER_HOME/bin:$ANDROID_HOME/tools:$PATH

USER root

RUN apt-get update && \
    apt-get -y install gradle android-tools-adb android-tools-fastboot && \
    apt-get clean && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*;

USER gitpod

RUN cd /home/gitpod && wget -qO flutter_sdk.tar.xz https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.0.0-stable.tar.xz \
    && tar -xvf flutter_sdk.tar.xz && rm flutter_sdk.tar.xz && \
    wget -qO android_studio.zip https://dl.google.com/dl/android/studio/ide-zips/3.3.0.20/android-studio-ide-182.5199772-linux.zip && \
    unzip android_studio.zip && rm -f android_studio.zip && \
    wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r26.1.1-linux.tgz && tar -xvf android-sdk.tgz && rm android-sdk.tgz && \
    echo y | android update sdk --all --force --no-ui --filter platform-tools,build-tools-26.1.1,android-26,sys-img-armeabi-v7a-android-26