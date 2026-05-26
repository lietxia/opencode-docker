FROM ubuntu:24.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# 使用清华镜像源加速
RUN sed -i 's|http://archive.ubuntu.com|http://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list.d/ubuntu.sources \
    && sed -i 's|http://security.ubuntu.com|http://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list.d/ubuntu.sources

# 安装系统依赖、编程语言运行时及开发工具
RUN apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa && apt-get update \
    && apt-get install -y curl wget git build-essential ca-certificates \
    unzip zip jq htop tmux openssh-client rclone magic-wormhole \
    openjdk-21-jdk maven python3.13 python3.13-venv python3.13-dev \
    python3-pip php php-cli php-mbstring php-xml php-curl php-zip \
    && rm -rf /var/lib/apt/lists/*

# 设置 Python 3.13 为默认
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1 \
    && ln -sf /usr/bin/python3.13 /usr/bin/python

# 安装 Node.js (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# 安装 Bun
RUN curl -fsSL https://bun.sh/install | bash

# 安装 uv (Python 包管理器)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 安装 Go (支持多架构)
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then GOARCH=amd64; elif [ "$ARCH" = "arm64" ]; then GOARCH=arm64; else GOARCH="$ARCH"; fi \
    && wget -q "https://go.dev/dl/go1.23.5.linux-${GOARCH}.tar.gz" \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf "go1.23.5.linux-${GOARCH}.tar.gz" \
    && rm "go1.23.5.linux-${GOARCH}.tar.gz"

# 安装 Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 安装 OpenCode CLI
RUN curl -fsSL https://opencode.ai/install | bash

# 创建工作目录
RUN mkdir -p /workspace
WORKDIR /workspace

# 统一设置所有 PATH
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.bun/bin:/root/.cargo/bin:/usr/local/go/bin:/root/.local/bin:/root/.opencode/bin:${JAVA_HOME}/bin"

# 验证所有安装
RUN echo "=== 环境验证 ===" \
    && echo "--- Python ---" && python3 --version && python --version \
    && echo "--- Node.js ---" && node --version && npm --version \
    && echo "--- Bun ---" && bun --version \
    && echo "--- uv ---" && uv --version \
    && echo "--- Go ---" && go version \
    && echo "--- Rust ---" && rustc --version && cargo --version \
    && echo "--- Java ---" && java --version && mvn --version \
    && echo "--- PHP ---" && php --version \
    && echo "--- OpenCode ---" && /root/.opencode/bin/opencode --version \
    && echo "--- Rclone ---" && rclone version \
    && echo "=== 验证完成 ==="

# 设置入口和默认命令
ENTRYPOINT ["/root/.opencode/bin/opencode"]
CMD ["web", "--port", "4096", "--hostname", "0.0.0.0"]
