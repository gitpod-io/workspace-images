ARG base
FROM ${base}

ARG GO_VERSION

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1
ENV GO_VERSION=${GO_VERSION}
ENV GOPATH=$HOME/go-packages
ENV GOROOT=$HOME/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH
RUN curl -fsSL https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz | tar xzs && \
# install VS Code Go tools for use with gopls as per https://github.com/golang/vscode-go/blob/master/docs/tools.md
# also https://github.com/golang/vscode-go/blob/27bbf42a1523cadb19fad21e0f9d7c316b625684/src/goTools.ts#L139
    go get -v \
        github.com/uudashr/gopkgs/cmd/gopkgs@v2 \
        github.com/ramya-rao-a/go-outline \
        github.com/cweill/gotests/gotests \
        github.com/fatih/gomodifytags \
        github.com/josharian/impl \
        github.com/haya14busa/goplay/cmd/goplay \
        github.com/go-delve/delve/cmd/dlv \
        github.com/golangci/golangci-lint/cmd/golangci-lint && \
    GO111MODULE=on go get -v \
        golang.org/x/tools/gopls@v0.7.4 && \
    sudo rm -rf $GOPATH/src $GOPATH/pkg /home/gitpod/.cache/go /home/gitpod/.cache/go-build
# user Go packages
ENV GOPATH=/workspace/go \
    PATH=/workspace/go/bin:$PATH
