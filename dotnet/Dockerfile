FROM gitpod/workspace-full:latest

USER gitpod

# Install .NET Core 5.0 SDK binaries on Ubuntu 20.04
# Source: https://dev.to/carlos487/installing-dotnet-core-in-ubuntu-20-04-6jh
RUN mkdir -p /home/gitpod/dotnet && curl -fsSL https://download.visualstudio.microsoft.com/download/pr/a0487784-534a-4912-a4dd-017382083865/be16057043a8f7b6f08c902dc48dd677/dotnet-sdk-5.0.101-linux-x64.tar.gz | tar xz -C /home/gitpod/dotnet
ENV DOTNET_ROOT=/home/gitpod/dotnet
ENV PATH=$PATH:/home/gitpod/dotnet