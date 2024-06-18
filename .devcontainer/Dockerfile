FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://kcl-lang.io/script/install-cli.sh -O - | bash && \
    wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && \
    chmod +x /usr/bin/yq