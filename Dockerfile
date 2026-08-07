FROM ubuntu:26.04

# 系统依赖 + Node.js + Python 符号链接
RUN apt-get update && apt-get install -y \
    curl wget git build-essential ca-certificates \
    unzip zip jq htop tmux openssh-client npm \
    default-jdk maven composer rclone golang-go python3-pip magic-wormhole \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3 /usr/bin/python

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Bun
RUN curl -fsSL https://bun.sh/install | bash

# npm 全局工具
RUN npm i -g opencode-ai yarn pnpm

ENV PATH="/root/.cargo/bin:/root/.bun/bin:/root/.local/bin:${PATH}"

WORKDIR /code

ENTRYPOINT ["opencode"]
CMD ["web", "--port", "4096", "--hostname", "0.0.0.0"]
