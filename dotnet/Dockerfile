FROM gitpod/workspace-full:latest

RUN wget -q "https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb" && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    sudo rm -f packages-microsoft-prod.deb && \
    sudo add-apt-repository universe && \
    sudo apt-get update && \
    sudo DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get -y -o APT::Install-Suggests="true" install \
        dotnet-sdk-2.2 \
        dotnet-sdk-3.1 \
    && sudo apt-key adv --keyserver "hkp://keyserver.ubuntu.com:80" --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list \
    && sudo apt-get update \ 
    && sudo apt-get install -yq \
        mono-devel \
        mono-complete \
        fsharp \
    && sudo rm -rf /var/lib/apt/lists/*
