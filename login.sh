#!/usr/bin/env bash
# 为一台正在运行的 OpenCode 2 服务器生成一次性登录链接（浏览器打开即登录，30 天免密）
#
# 用法：
#   ./login.sh                       # 默认 http://127.0.0.1:4096
#   ./login.sh http://192.168.1.10:4096
#   OPENCODE_PASSWORD=yourpass ./login.sh http://myhost:4096
set -euo pipefail

BASE="${1:-http://127.0.0.1:4096}"
BASE="${BASE%/}"
PASS="${OPENCODE_PASSWORD:-lede}"

RESP="$(curl -fsS --user "opencode:${PASS}" -X POST "${BASE}/api/pair")" || {
  echo "无法连接 ${BASE}，检查地址/密码（当前用 opencode:${PASS}）" >&2
  exit 1
}

CODE="$(printf '%s' "$RESP" | sed -n 's/.*"code"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
[ -n "$CODE" ] || { echo "返回内容无法解析: $RESP" >&2; exit 1; }

echo "${BASE}/auth/connect/${CODE}"
echo "# 5 分钟内有效；打开后写入 30 天会话 cookie" >&2
