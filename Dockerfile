FROM ubuntu:26.04

ARG OPENCODE_VERSION=2.2.5

ENV DEBIAN_FRONTEND=noninteractive

# git/ripgrep 是 OpenCode 的功能依赖，curl 用于安装和健康检查
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl git ripgrep tar \
    && rm -rf /var/lib/apt/lists/*

# 官方安装脚本：固定版本，且不修改 shell 配置
RUN curl -fsSL https://opencode.ai/v2/install \
    | bash -s -- --version "${OPENCODE_VERSION}" --no-modify-path

ENV PATH="/root/.opencode/bin:${PATH}"

WORKDIR /code

# 4096 = OpenCode 2 WebUI / API
EXPOSE 4096

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD curl -fsS -o /dev/null "http://127.0.0.1:4096/" || exit 1

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["serve", "--hostname", "0.0.0.0", "--port", "4096"]
