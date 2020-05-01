FROM gitpod/workspace-full:latest

USER gitpod

# Install .NET Core 3.1 SDK binaries on Ubuntu 20.04
# Source: https://dev.to/carlos487/installing-dotnet-core-in-ubuntu-20-04-6jh
RUN mkdir -p /home/gitpod/dotnet && curl -fsSL https://download.visualstudio.microsoft.com/download/pr/f65a8eb0-4537-4e69-8ff3-1a80a80d9341/cc0ca9ff8b9634f3d9780ec5915c1c66/dotnet-sdk-3.1.201-linux-x64.tar.gz | tar xz -C /home/gitpod/dotnet
ENV DOTNET_ROOT=/home/gitpod/dotnet
ENV PATH=$PATH:/home/gitpod/dotnet

# Install F# with Mono
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list \
 && sudo apt-get update \
 && sudo apt-get install -y \
    mono-complete \
    fsharp \
 && sudo rm -rf /var/lib/apt/lists/*
