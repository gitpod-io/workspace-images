FROM gitpod/workspace-dart-vnc

ENV ANDROID_HOME=/home/gitpod/android-sdk-linux \
    FLUTTER_HOME=/home/gitpod/flutter \
    PATH=$FLUTTER_HOME/bin:$ANDROID_HOME/tools:$PATH

USER root

RUN apt-get -y install gradle && \
    apt-get clean && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*;

USER gitpod

RUN cd /home/gitpod && wget -qO flutter_sdk.tar.xz https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.0.0-stable.tar.xz \
    && tar -xvf flutter_sdk.tar.xz && rm flutter_sdk.tar.xz && \
    wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && tar -xvf android-sdk.tgz && rm android-sdk.tgz && \
    echo y | android update sdk --all --force --no-ui --filter platform-tools,build-tools-21.1.1,android-21,sys-img-armeabi-v7a-android-21 && \
    echo "no" | android create avd \
                --name gitpod \
                --target android-21 \
                --abi armeabi-v7a && \
    for f in "${HOME}/.android" "${HOME}/android-sdk-linux"; do \
      sudo chgrp -R 0 ${f} && \
      sudo chmod -R g+rwX ${f}; \
    done;