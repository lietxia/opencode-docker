FROM ubuntu:26.04

# 系统依赖 + Node.js + Python 符号链接
RUN apt-get update && apt-get install -y \
    curl wget git build-essential ca-certificates \
    unzip zip jq htop tmux openssh-client \
    && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y \
    default-jdk maven composer rclone golang-go python3-pip magic-wormhole \
    nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3 /usr/bin/python

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Bun
RUN curl -fsSL https://bun.sh/install | bash

# npm 全局工具
RUN npm i -g opencode-ai @openai/codex yarn pnpm

# uv + Claude Code
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && curl -fsSL https://claude.ai/install.sh | bash

ENV PATH="/root/.cargo/bin:/root/.bun/bin:/root/.local/bin:${PATH}"

WORKDIR /workspace

ENTRYPOINT ["opencode"]
CMD ["web", "--port", "4096", "--hostname", "0.0.0.0"]
