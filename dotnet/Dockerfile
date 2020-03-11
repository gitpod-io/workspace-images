FROM gitpod/workspace-full:latest

USER root
RUN wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm -rf packages-microsoft-prod.deb && \
    add-apt-repository universe && \
    apt-get update && \
    echo resolvconf resolvconf/linkify-resolvconf boolean false | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get -y -o APT::Install-Suggests="true" install \
        dotnet-sdk-2.2 \
        dotnet-sdk-3.1 \
        fsharp \
        mono-complete && \
    rm -rf /var/lib/apt/lists/*
