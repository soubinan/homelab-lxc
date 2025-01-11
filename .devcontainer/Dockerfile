FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y &&
    apt-get install -y \
        build-essential \
        gnupg2 \
        debootstrap \
        squashfs-tools \
        make \
        rsync \
        curl \
        jq \
        wget \
        git \
        vim \
        unzip &&
    apt-get clean all &&
    rm -rf /var/lib/apt/lists/*

RUN wget -q https://kcl-lang.io/script/install-cli.sh -O - | bash &&
    wget -q https://kcl-lang.io/script/install-kcl-lsp.sh -O - | bash &&
    wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&
    chmod +x /usr/bin/yq

RUN VERSION=$(curl -sL --url "https://golang.org/VERSION?m=text" | grep go) &&
    wget -q https://go.dev/dl/${VERSION}.linux-amd64.tar.gz -O /tmp/go.tar.gz &&
    tar -C /usr/local -xzf /tmp/go.tar.gz &&
    rm /tmp/go.tar.gz &&
    ln -s /usr/local/go/bin/go /usr/local/bin/go

RUN go install -v -x github.com/lxc/distrobuilder/distrobuilder@latest &&
    ln -s /root/go/bin/distrobuilder /usr/local/bin/distrobuilder
