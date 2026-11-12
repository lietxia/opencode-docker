#!/bin/sh
# OpenCode 2 镜像入口：先校验 CLI 大版本，再执行命令。
# 目的：如果镜像还是旧的 v1（opencode-ai），直接报错，避免静默跑错版本。
set -eu

VERSION="$(opencode --version 2>/dev/null || true)"
MAJOR="$(printf '%s' "$VERSION" | sed -n 's/.* v\([0-9][0-9]*\)\..*/\1/p')"

if [ -z "$MAJOR" ] || [ "$MAJOR" -lt 2 ]; then
    echo "错误：镜像内 OpenCode 版本为 '${VERSION:-未知}'，不是 v2。" >&2
    echo "先运行 ./build.sh 重建镜像，再 docker compose up -d。" >&2
    exit 1
fi

exec opencode "$@"
